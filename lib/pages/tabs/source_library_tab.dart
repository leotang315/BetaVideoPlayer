import 'package:beta_player/models/video_sot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/video_source.dart';
import '../../providers/video_source_provider.dart';
import '../common/video_source_add_dialog.dart';
import '../common/video_source_options_dialog.dart';

class SourceLibraryTab extends StatelessWidget {
  const SourceLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资源库'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSourceDialog(context),
          ),
        ],
      ),
      body: Consumer<VideoSourceProvider>(
        builder: (context, provider, child) {
          final localSources = provider.getVideoSourcesByType(
            VideoSourceClass.localStorage,
          );
          final networkSources = provider.getVideoSourcesByType(
            VideoSourceClass.networkStorage,
          );

          final cloudSources = provider.getVideoSourcesByType(
            VideoSourceClass.cloudStorage,
          );

          return ListView(
            children: [
              if (localSources.isNotEmpty) ...[
                _buildSourceTypeHeader('本地目录'),
                ...localSources.map(
                  (source) => _buildSourceItem(context, source),
                ),
              ],
              if (networkSources.isNotEmpty) ...[
                _buildSourceTypeHeader('百度网盘'),
                ...networkSources.map(
                  (source) => _buildSourceItem(context, source),
                ),
              ],
              if (cloudSources.isNotEmpty) ...[
                _buildSourceTypeHeader('百度网盘'),
                ...cloudSources.map(
                  (source) => _buildSourceItem(context, source),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSourceTypeHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildSourceItem(BuildContext context, VideoSourceBase source) {
    return ListTile(
      leading: _getSourceIcon(source.type),
      title: Text(source.name),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () => _showSourceOptions(context, source),
      ),
    );
  }

  Widget _getSourceIcon(VideoSourceClass type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case VideoSourceClass.localStorage:
        iconData = Icons.folder;
        iconColor = Colors.blue;
        break;
      case VideoSourceClass.networkStorage:
        iconData = Icons.computer;
        iconColor = Colors.green;
        break;
      case VideoSourceClass.cloudStorage:
        iconData = Icons.cloud;
        iconColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  void _showAddSourceDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VideoSourceAddDialog()),
    );
  }

  void _showSourceOptions(BuildContext context, VideoSourceBase source) {
    showDialog(
      context: context,
      builder: (context) => VideoSourceOptionsDialog(source: source),
    );
  }
}
