
import 'package:beta_player/providers/recent_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'models/video_source.dart';
import 'screens/home_screen.dart';
import 'providers/video_provider.dart';
import 'screens/main_screen.dart';



void main() {
  fvp.registerWith();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => RecentPlayProvider()), // 添加 RecentPlayProvider
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
      home: MainScreen(),
    );
  }
}
