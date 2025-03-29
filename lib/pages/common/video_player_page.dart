import 'package:beta_player/providers/video_source_provider.dart';
import 'package:beta_player/services/metadata/metadata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/play_list.dart';
import '../../models/video_file.dart';
import '../../models/video_source.dart';

import '../../providers/recent_play_provider.dart';
import '../../providers/video_file_provider.dart';
import '../../providers/video_meta_provider.dart';

class VideoPlayerPage extends StatefulWidget {
  final PlayList playlist;

  const VideoPlayerPage({super.key, required this.playlist});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late final PlayList _playlist;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  double _volume = 1.0;
  final List<double> _playbackRates = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _playlist = widget.playlist;
    _initializePlayer();

    // context.read<RecentPlayProvider>().addRecentPlay(_playlist.currentVideo!);
  }

  Future<void> _playNext() async {
    if (!_playlist.hasNext) return;
    await _controller.dispose();
    setState(() {
      _isInitialized = false;
      _playlist.currentIndex++;
    });
    await _initializePlayer();
    _controller.play();
  }

  Future<void> _playPrevious() async {
    if (!_playlist.hasPrevious) return;
    await _controller.dispose();
    setState(() {
      _isInitialized = false;
      _playlist.currentIndex--;
    });
    await _initializePlayer();
    _controller.play();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours =
        duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours$minutes:$seconds';
  }

  Future<void> _initializePlayer() async {
    final videoSourceProvider = context.read<VideoSourceProvider>();
    final videoMetaProvider = context.read<VideoMetaProvider>();
    final videoFileProvider = context.read<VideoFileProvider>();
    final videoSource = videoSourceProvider.findVideoSourceByID(
      _playlist.currentVideo!.videoSourceId,
    );

    switch (videoSource!.type) {
      case VideoSourceType.local:
        _controller = VideoPlayerController.file(
          File(_playlist.currentVideo!.path),
        );
        break;
      case VideoSourceType.smb:
      case VideoSourceType.webDav:
      case VideoSourceType.baiduCloud:
        // Implementation for other sources...
        break;
    }
    await _controller.initialize();
    _controller.addListener(_videoListener);
    setState(() {
      _isInitialized = true;
    });
  }

  void _videoListener() {
    setState(() {});
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        color: Colors.black54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar and time
            Row(
              children: [
                Text(_formatDuration(_controller.value.position)),
                Expanded(
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                Text(_formatDuration(_controller.value.duration)),
              ],
            ),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: _playlist.hasPrevious ? _playPrevious : null,
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed:
                      () => setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      }),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: _playlist.hasNext ? _playNext : null,
                ),
                // Volume control
                Row(
                  children: [
                    Icon(Icons.volume_up),
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                            _controller.setVolume(_volume);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // Playback speed
                PopupMenuButton<double>(
                  icon: Icon(Icons.speed),
                  onSelected: (speed) {
                    setState(() {
                      _controller.setPlaybackSpeed(speed);
                    });
                  },
                  itemBuilder: (context) {
                    return _playbackRates.map((rate) {
                      return PopupMenuItem(
                        value: rate,
                        child: Text('${rate}x'),
                        enabled: _controller.value.playbackSpeed != rate,
                      );
                    }).toList();
                  },
                ),
                // Settings
                PopupMenuButton(
                  icon: Icon(Icons.settings),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          child: Text('画质设置'),
                          onTap: () {
                            // Implement quality settings
                          },
                        ),
                        PopupMenuItem(
                          child: Text('字幕设置'),
                          onTap: () {
                            // Implement subtitle settings
                          },
                        ),
                      ],
                ),
                IconButton(
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _toggleFullScreen();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar:
            _isFullScreen
                ? null
                : AppBar(title: Text(_playlist.currentVideo?.name ?? '')),
        body: Center(
          child:
              _isInitialized
                  ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        _buildControls(),
                      ],
                    ),
                  )
                  : CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }
}
