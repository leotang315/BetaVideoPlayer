import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recent_play_provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.history),
            title: Text('播放历史'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 导航到播放历史页面
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 导航到设置页面
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('清除播放历史'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('确认清除'),
                  content: Text('是否清除所有播放历史？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<RecentPlayProvider>().clearRecentPlays();
                        Navigator.pop(context);
                      },
                      child: Text('确认'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 显示关于信息
            },
          ),
        ],
      ),
    );
  }
} 