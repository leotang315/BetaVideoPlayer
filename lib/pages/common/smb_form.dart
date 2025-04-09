import 'package:beta_player/pages/file_browser_page.dart';
import 'package:beta_player/pages/file_browser_page2.dart';
import 'package:beta_player/services/file_source_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/video_source.dart';
import '../../providers/video_source_provider.dart';

class SMBForm extends StatefulWidget {
  @override
  _SMBFormState createState() => _SMBFormState();
}

class _SMBFormState extends State<SMBForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _port = '445';
  String _username = '';
  String _password = '';
  String _path = '';
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('添加 SMB')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                decoration: InputDecoration(labelText: '地址*'),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '端口'),
                initialValue: '445',
                onChanged: (value) {
                  setState(() {
                    _port = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '用户名'),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '密码',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '路径'),
                onChanged: (value) {
                  setState(() {
                    _path = value;
                  });
                },
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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // 显示加载指示器
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // 创建临时 source 用于测试连接
        final tempSource = VideoSourceSmb(
          _name,
          '$_address:$_port',
          _username,
          _password,
          '/',
        );

        // 测试连接
        final fileManager = SmbFileManager(
          host: _address,
          username: _username,
          password: _password,
        );
        // await fileManager.list('/'); // 如果连接失败会抛出异常

        // 关闭加载指示器
        Navigator.pop(context);

        await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder:
                (context) => FileBrowserPage2(
                  source: tempSource,
                  fileManager: fileManager,
                  initialPath: '/video',
                ),
          ),
        );

        // // 打开文件浏览器选择路径
        // final selectedPath = await Navigator.push<String>(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (context) => FileBrowserPage(
        //           source: tempSource,
        //           fileManager: fileManager,
        //         ),
        //   ),
        // );

        // if (selectedPath != null) {
        //   // 创建最终的 source 并添加到 provider
        //   final provider = context.read<VideoSourceProvider>();
        //   final source = VideoSourceSmb(
        //     _name,
        //     '$_address:$_port',
        //     _username,
        //     _password,
        //     selectedPath,
        //   );

        //   provider.addVideoSource(source);
        //Navigator.pop(context); // 返回到上一页
        //}
      } catch (e) {
        // 关闭加载指示器（如果还在显示）
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route is! DialogRoute);
        }

        // 显示错误信息
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('连接失败: $e')));
        }
      }
    }
  }
}
