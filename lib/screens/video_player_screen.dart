import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/video_provider.dart';
import '../models/video_source.dart';
import '../providers/recent_play_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  late VideoSource _videoSource;
  bool _isFullScreen = false;
  double _volume = 1.0;
  final List<double> _playbackRates = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _videoSource = context.read<VideoProvider>().currentVideo!;
    _initializePlayer();
    if (_videoSource.currentVideo != null) {
      context.read<RecentPlayProvider>().addRecentVideo(_videoSource.currentVideo!);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours$minutes:$seconds';
  }

  Future<void> _initializePlayer() async {
    if (_videoSource.currentVideo == null) return;

    switch (_videoSource.type) {
      case SourceType.local:
        _controller = VideoPlayerController.file(
          File(_videoSource.currentVideo!.path)
        );
        break;
      case SourceType.smb:
      case SourceType.webdav:
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
                  onPressed: _videoSource.hasPrevious ? _playPrevious : null,
                ),
                IconButton(
                  icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () => setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: _videoSource.hasNext ? _playNext : null,
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
                  itemBuilder: (context) => [
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
                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playNext() async {
    if (!_videoSource.hasNext) return;
    await _controller.dispose();
    setState(() {
      _isInitialized = false;
      _videoSource.currentIndex++;
    });
    await _initializePlayer();
    _controller.play();
  }

  Future<void> _playPrevious() async {
    if (!_videoSource.hasPrevious) return;
    await _controller.dispose();
    setState(() {
      _isInitialized = false;
      _videoSource.currentIndex--;
    });
    await _initializePlayer();
    _controller.play();
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
        appBar: _isFullScreen ? null : AppBar(
          title: Text(_videoSource.currentVideo?.name ?? ''),
        ),
        body: Center(
          child: _isInitialized
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
