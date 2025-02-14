
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'models/video_source.dart';
import 'screens/home_screen.dart';
import 'providers/video_provider.dart';



void main() {
  fvp.registerWith();
  runApp(
     ChangeNotifierProvider(
      create: (_) => VideoProvider(),
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
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}
