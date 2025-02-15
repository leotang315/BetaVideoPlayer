import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beta_player/models/video_source.dart';
import '../providers/video_provider.dart';
import 'video_player_screen.dart';

class AllSourcesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('全部媒体库'),
      ),
      body: Consumer<VideoProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.videos.length,
            itemBuilder: (context, index) {
              final source = provider.videos[index];
              return ExpansionTile(
                leading: Icon(_getSourceIcon(source.type)),
                title: Text(source.name),
                subtitle: Text('${source.playlist.length} 个视频'),
                children: source.playlist.map((video) => ListTile(
                  title: Text(video.name),
                  onTap: () {
                    provider.setCurrentVideo(source);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(),
                      ),
                    );
                  },
                )).toList(),
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
} 