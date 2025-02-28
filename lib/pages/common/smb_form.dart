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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<VideoSourceProvider>();
      VideoSourceBase source = VideoSourceSmb(
        VideoSourceClass.networkStorage,
        _name,
        '$_address:$_port',
        _username,
        _password,
        _path,
      );

      provider.addVideoSource(source);
      Navigator.pop(context);
      Navigator.pop(context); // 返回到资源库页面
    }
  }
}
