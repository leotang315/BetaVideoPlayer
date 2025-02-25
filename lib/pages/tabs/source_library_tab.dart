import 'package:beta_player/models/video_sot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../common/video_source_dialog.dart';
import '../../models/video_sot.dart';

class SourceLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('资源库'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (context) => VideoSourceDialog(),
                ),
          ),
        ],
      ),
      body: Consumer<VideoProvider>(
        builder: (context, provider, child) {
          if (provider.videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('暂无媒体库'),
                  ElevatedButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder: (context) => VideoSourceDialog(),
                        ),
                    child: Text('添加媒体库'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.videos.length,
            itemBuilder: (context, index) {
              final source = provider.videos[index];
              return ListTile(
                leading: Icon(_getSourceIcon(source.type)),
                title: Text(source.name),
                subtitle: Text('${source.playlist.length} 个视频'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => provider.removeVideo(source),
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
}
