import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/video_source.dart';
import '../../providers/video_file_provider.dart';
import '../../providers/video_meta_provider.dart';
import '../../providers/video_source_provider.dart';
import '../../services/import_manager.dart';

class LocalForm extends StatefulWidget {
  @override
  _SMBConfigPageState createState() => _SMBConfigPageState();
}

class _SMBConfigPageState extends State<LocalForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _path = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('添加本地配置')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '名称'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '路径',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.folder_open),
                    onPressed: _pickLocalPath,
                  ),
                ),
                readOnly: true,
                onTap: _pickLocalPath,
                controller: TextEditingController(text: _path),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('确认添加'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickLocalPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _path = selectedDirectory;
      });
    }
  }

  // void _submitForm() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     final provider = context.read<VideoSourceProvider>();
  //     VideoSourceBase source = VideoSourceLocalPath(
  //       VideoSourceClass.localStorage,
  //       _name,
  //       _path,
  //     );

  //     provider.addVideoSource(source);
  //     Navigator.pop(context);
  //     Navigator.pop(context); // 返回到资源库页面
  //   }
  // }
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final sourceProvider = context.read<VideoSourceProvider>();
      final fileProvider = context.read<VideoFileProvider>();
      final metaProvider = context.read<VideoMetaProvider>();

      // 创建并保存视频源
      VideoSourceBase source = VideoSourceLocalPath(
        VideoSourceClass.localStorage,
        _name,
        _path,
      );
      await sourceProvider.addVideoSource(source);

      // 显示加载对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在导入视频文件...'),
                ],
              ),
            ),
      );

      try {
        // 使用ImportManager进行导入和刮削
        final importManager = ImportManager(
          fileProvider: fileProvider,
          metaProvider: metaProvider,
        );
        await importManager.importFromSource(source);

        // 关闭加载对话框
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context); // 返回到资源库页面

        // 显示成功消息
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('视频文件导入完成')));
        }
      } catch (e) {
        // 关闭加载对话框并显示错误
        Navigator.pop(context);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('导入失败: $e')));
        }
      }
    }
  }
}
