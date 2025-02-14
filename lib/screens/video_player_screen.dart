import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/video_provider.dart';
import '../models/video_source.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  late VideoSource _videoSource;

  @override
  void initState() {
    super.initState();
    _videoSource = context.read<VideoProvider>().currentVideo!;
    _initializePlayer();
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
    setState(() {
      _isInitialized = true;
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_videoSource.currentVideo?.name ?? ''),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: _videoSource.hasPrevious ? _playPrevious : null,
            ),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: _videoSource.hasNext ? _playNext : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
