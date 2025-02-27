import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/video_source.dart';
import '../../providers/video_source_provider.dart';

class VideoSourceOptionsDialog extends StatelessWidget {
  final VideoSourceBase source;

  const VideoSourceOptionsDialog({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<VideoSourceProvider>();

    return SimpleDialog(
      title: Text(source.name),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            _importVideos(context);
          },
          child: const ListTile(
            leading: Icon(Icons.download),
            title: Text('导入新资源'),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            _manageVideos(context);
          },
          child: const ListTile(
            leading: Icon(Icons.folder),
            title: Text('管理已导入资源'),
          ),
        ),
        SimpleDialogOption(
          onPressed: () async {
            Navigator.pop(context);
            await provider.removeVideoSource(source);
          },
          child: const ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('删除此资源', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Future<void> _importVideos(BuildContext context) async {
    final provider = context.read<VideoSourceProvider>();

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // await provider.importVideosFromSource(source);

      Navigator.pop(context); // 关闭加载对话框
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('导入完成')));
      }
    } catch (e) {
      Navigator.pop(context); // 关闭加载对话框
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导入失败: $e')));
      }
    }
  }

  void _manageVideos(BuildContext context) {
    // TODO: 实现资源管理页面导航
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SourceVideosPage(source: source),
    //   ),
    // );
  }
}
