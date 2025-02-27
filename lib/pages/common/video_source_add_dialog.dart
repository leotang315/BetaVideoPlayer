import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/video_sot.dart';
import '../../providers/video_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../models/video_source.dart';
import '../../providers/video_source_provider.dart';

class VideoSourceAddDialog extends StatefulWidget {
  @override
  _VideoSourceDialogState createState() => _VideoSourceDialogState();
}

class _VideoSourceDialogState extends State<VideoSourceAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pathController = TextEditingController();
  SourceType _sourceType = SourceType.local;
  String _name = '';
  String _path = '';
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加视频源'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<SourceType>(
                value: _sourceType,
                items:
                    SourceType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sourceType = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '名称'),
                onSaved: (value) => _name = value!,
                validator: (value) => value?.isEmpty ?? true ? '请输入名称' : null,
              ),
              if (_sourceType != SourceType.local)
                TextFormField(
                  decoration: InputDecoration(labelText: '用户名'),
                  onSaved: (value) => _username = value,
                ),
              if (_sourceType != SourceType.local)
                TextFormField(
                  decoration: InputDecoration(labelText: '密码'),
                  obscureText: true,
                  onSaved: (value) => _password = value,
                ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pathController,
                      decoration: InputDecoration(labelText: '路径'),
                      onSaved: (value) => _path = value!,
                      validator:
                          (value) => value?.isEmpty ?? true ? '请输入路径' : null,
                    ),
                  ),
                  if (_sourceType == SourceType.local)
                    IconButton(
                      icon: Icon(Icons.folder_open),
                      onPressed: _pickFile,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('取消')),
        ElevatedButton(onPressed: _submit, child: Text('添加')),
      ],
    );
  }

  Future<void> _pickFile() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      setState(() {
        _path = selectedDirectory;
        _pathController.text = _path;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      List<VideoFile> playlist = [];

      if (_sourceType == SourceType.local) {
        Directory dir = Directory(_path);
        await for (var entity in dir.list(recursive: true)) {
          if (entity is File) {
            String ext = path.extension(entity.path).toLowerCase();
            if (['.mp4', '.avi', '.mkv', '.mov', '.wmv'].contains(ext)) {
              playlist.add(
                VideoFile(name: path.basename(entity.path), path: entity.path),
              );
            }
          }
        }
      }

      final video = VideoSource(
        name: _name,
        path: _path,
        type: _sourceType,
        playlist: playlist,
        credentials:
            _sourceType != SourceType.local
                ? {'username': _username!, 'password': _password!}
                : null,
      );

      context.read<VideoProvider>().addVideo(video);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }
}

class VideoSourceTypeDialog extends StatelessWidget {
  const VideoSourceTypeDialog({super.key});

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
            type: VideoSourceType.localStorage,
          ),
          _buildSectionHeader('网络存储'),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_outlined,
            iconColor: Colors.blue,
            title: 'WebDAV',
            type: VideoSourceType.networkStorage,
            tag: 'Beta',
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.computer,
            iconColor: Colors.blue,
            title: 'SMB',
            type: VideoSourceType.networkStorage,
            tag: 'Beta',
          ),
          _buildSectionHeader('云盘存储'),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud,
            iconColor: Colors.orange,
            title: '阿里云盘',
            type: VideoSourceType.cloudStorage,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_circle,
            iconColor: Colors.blue,
            title: '百度网盘',
            type: VideoSourceType.cloudStorage,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_queue,
            iconColor: Colors.blue,
            title: '中国移动云盘',
            type: VideoSourceType.cloudStorage,
            tag: 'New',
            tagColor: Colors.red,
          ),
          _buildSourceTypeItem(
            context: context,
            icon: Icons.cloud_done,
            iconColor: Colors.blue,
            title: '123云盘',
            type: VideoSourceType.cloudStorage,
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
        builder: (context) => VideoSourceConfigDialog(type: type, title: title),
      ),
    );
  }
}

class VideoSourceConfigDialog extends StatefulWidget {
  final VideoSourceType type;
  final String title;

  const VideoSourceConfigDialog({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<VideoSourceConfigDialog> createState() =>
      _VideoSourceConfigDialogState();
}

class _VideoSourceConfigDialogState extends State<VideoSourceConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pathController = TextEditingController();
  final _addressController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    _addressController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
        actions: [TextButton(onPressed: _submitForm, child: const Text('确定'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? '请输入名称' : null,
            ),
            const SizedBox(height: 16),
            if (widget.type != VideoSourceType.cloudStorage) ...[
              TextFormField(
                controller: _pathController,
                decoration: const InputDecoration(
                  labelText: '路径',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? '请输入路径' : null,
              ),
              const SizedBox(height: 16),
            ],
            if (widget.type == VideoSourceType.networkStorage) ...[
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '地址',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? '请输入地址' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? '请输入用户名' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? '请输入密码' : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<VideoSourceProvider>();
      VideoSourceBase source;

      switch (widget.type) {
        case VideoSourceType.localStorage:
          source = VideoSourceLocalPath(
            widget.type,
            _nameController.text,
            _pathController.text,
          );
          break;
        case VideoSourceType.networkStorage:
          source = VideoSourceSmb(
            widget.type,
            _nameController.text,
            _addressController.text,
            _userController.text,
            _passwordController.text,
            _pathController.text,
          );
          break;
        case VideoSourceType.cloudStorage:
          // 云盘存储的具体实现
          source = VideoSourceBaiduCloud(widget.type, _nameController.text);
          break;
      }

      provider.addVideoSource(source);
      Navigator.pop(context);
      Navigator.pop(context); // 返回到资源库页面
    }
  }
}
