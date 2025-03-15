import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/card_info.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../models/video_source.dart';
import '../../providers/video_source_provider.dart';
import 'local_form.dart';
import 'smb_form.dart';

class VideoSourceAddDialog extends StatelessWidget {
  const VideoSourceAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('添加新文件源'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('本地存储'),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.folder,
            iconColor: Colors.blue,
            title: '本地目录',
            type: VideoSourceType.local,
          ),
          _buildSectionHeader('网络存储'),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_outlined,
            iconColor: Colors.blue,
            title: 'WebDAV',
            type: VideoSourceType.webDav,
            tag: 'Beta',
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.computer,
            iconColor: Colors.blue,
            title: 'SMB',
            type: VideoSourceType.smb,
            tag: 'Beta',
          ),
          _buildSectionHeader('云盘存储'),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud,
            iconColor: Colors.orange,
            title: '阿里云盘',
            type: VideoSourceType.baiduCloud,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_circle,
            iconColor: Colors.blue,
            title: '百度网盘',
            type: VideoSourceType.baiduCloud,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_queue,
            iconColor: Colors.blue,
            title: '中国移动云盘',
            type: VideoSourceType.baiduCloud,
            tag: 'New',
            tagColor: Colors.red,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_done,
            iconColor: Colors.blue,
            title: '123云盘',
            type: VideoSourceType.baiduCloud,
            tag: 'Beta',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  Widget _buildSourceTypeItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VideoSourceType type,
    String? tag,
    Color tagColor = Colors.blue,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Row(
        children: [
          Text(title),
          if (tag != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(tag, style: TextStyle(fontSize: 12, color: tagColor)),
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showSourceConfigDialog(context, type, title),
    );
  }

  void _showSourceConfigDialog(
    BuildContext context,
    VideoSourceType type,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => switch (type) {
              VideoSourceType.local => LocalForm(),
              VideoSourceType.smb => SMBForm(),
              _ => SMBForm(),
            },
      ),
    );
  }
}
