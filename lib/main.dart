import 'package:beta_player/providers/recent_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'models/video_source.dart';
import 'providers/video_provider.dart';
import 'pages/main_page.dart';
import 'providers/video_source_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(VideoSourceTypeAdapter());
  Hive.registerAdapter(VideoSourceBaseAdapter());
  Hive.registerAdapter(VideoSourceLocalPathAdapter());
  Hive.registerAdapter(VideoSourceSmbAdapter());
  Hive.registerAdapter(VideoSourceWebDavAdapter());
  Hive.registerAdapter(VideoSourceBaiduCloudAdapter());

  // Initialize provider
  final videoSourceProvider = VideoSourceProvider();
  await videoSourceProvider.init();

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
