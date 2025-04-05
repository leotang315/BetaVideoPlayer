import 'package:beta_player/providers/recent_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'models/video_file.dart';
import 'models/video_meta.dart';
import 'models/video_source.dart';

import 'pages/main_page.dart';
import 'providers/video_source_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/video_file_provider.dart';
import 'providers/video_meta_provider.dart';
import 'package:file_picker/file_picker.dart';

import 'services/config_manager.dart';
import 'services/image_cache_service.dart';

void main() async {
  // Initialize ConfigManager
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(VideoSourceClassAdapter());
  Hive.registerAdapter(VideoSourceTypeAdapter());
  Hive.registerAdapter(VideoSourceBaseAdapter());
  Hive.registerAdapter(VideoSourceLocalPathAdapter());
  Hive.registerAdapter(VideoSourceSmbAdapter());
  Hive.registerAdapter(VideoSourceWebDavAdapter());
  Hive.registerAdapter(VideoSourceBaiduCloudAdapter());
  Hive.registerAdapter(VideoFileAdapter());
  Hive.registerAdapter(VideoTypeAdapter());
  Hive.registerAdapter(VideoMetadataAdapter());
  Hive.registerAdapter(MovieMetadataAdapter());
  Hive.registerAdapter(TVShowMetadataAdapter());
  Hive.registerAdapter(SeasonAdapter());
  Hive.registerAdapter(EpisodeAdapter());

  // Initialize providers
  final videoSourceProvider = VideoSourceProvider();
  final videoFileProvider = VideoFileProvider();
  final videoMetaProvider = VideoMetaProvider();
  await videoSourceProvider.init();
  await videoFileProvider.init();
  await videoMetaProvider.init();

  // Register fvp
  fvp.registerWith();

  await ConfigManager.initialize();
  await ImageCacheService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: videoSourceProvider),
        ChangeNotifierProvider.value(value: videoFileProvider),
        ChangeNotifierProvider.value(value: videoMetaProvider),
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
      title: 'Beta播放器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: MainPage(),
    );
  }
}
