import 'package:beta_player/providers/recent_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'providers/video_provider.dart';
import 'pages/main_page.dart';
import 'providers/video_source_provider.dart';

void main() {
  fvp.registerWith();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => VideoSourceProvider()),
        ChangeNotifierProvider(
          create: (_) => RecentPlayProvider(),
        ), // 添加 RecentPlayProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '视频播放器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: MainPage(),
    );
  }
}
