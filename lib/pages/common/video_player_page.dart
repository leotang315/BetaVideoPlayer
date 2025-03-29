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
  bool _showControls = true;
  bool _showVolumeSlider = false;
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
    _controller.setVolume(_volume); // 设置初始音量
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

  Widget _buildTopControls() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (_isFullScreen) {
                  _toggleFullScreen();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            Expanded(
              child: Text(
                _playlist.currentVideo?.name ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 4,
      child: VideoProgressIndicator(
        _controller,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor: Colors.blue,
          bufferedColor: Colors.grey.shade600,
          backgroundColor: Colors.grey.shade800,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          SizedBox(height: 8),
          Row(
            children: [
              // 左侧控制
              Text(
                '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),

              // 中间播放控制按钮组
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _playlist.hasPrevious ? _playPrevious : null,
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed:
                    () => setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    }),
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: _playlist.hasNext ? _playNext : null,
              ),

              Spacer(),
              // 右侧控制
              Container(
                width: 150, // 调整容器宽度以适应滑块
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _volume > 0 ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_volume > 0) {
                            _volume = 0;
                          } else {
                            _volume = 1.0;
                          }
                          _controller.setVolume(_volume);
                        });
                      },
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.white,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          trackHeight: 2.0,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 6.0,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 12.0,
                          ),
                        ),
                        child: Slider(
                          value: _volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                              _controller.setVolume(_volume);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildTopControls(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
          // 中间的播放按钮
          if (!_controller.value.isPlaying)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 48),
              ),
            ),
        ],
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
        backgroundColor: Colors.black,
        appBar: null, // 移除AppBar
        body:
            _isInitialized
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      _buildControls(),
                    ],
                  ),
                )
                : Center(child: CircularProgressIndicator()),
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
