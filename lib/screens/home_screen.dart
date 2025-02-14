import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../models/video_source.dart';
import 'video_player_screen.dart';
import 'source_dialog.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频播放器'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddSourceDialog(context),
          ),
        ],
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.videos.isEmpty) {
            return Center(
              child: Text('没有视频源，请点击右上角添加'),
            );
          }

          return ListView.builder(
            itemCount: videoProvider.videos.length,
            itemBuilder: (context, index) {
              final video = videoProvider.videos[index];
              return ListTile(
                leading: Icon(_getSourceIcon(video.type)),
                title: Text(video.name),
                subtitle: Text(video.path),
                onTap: () {
                  videoProvider.setCurrentVideo(video);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => videoProvider.removeVideo(video),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getSourceIcon(SourceType type) {
    switch (type) {
      case SourceType.local:
        return Icons.folder;
      case SourceType.smb:
        return Icons.computer;
      case SourceType.webdav:
        return Icons.cloud;
    }
  }

  void _showAddSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SourceDialog(),
    );
  }
} 