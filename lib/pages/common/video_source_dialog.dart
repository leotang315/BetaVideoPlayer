import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/video_sot.dart';
import '../../providers/video_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class VideoSourceDialog extends StatefulWidget {
  @override
  _VideoSourceDialogState createState() => _VideoSourceDialogState();
}

class _VideoSourceDialogState extends State<VideoSourceDialog> {
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
