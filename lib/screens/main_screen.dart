import 'package:flutter/material.dart';
import 'tabs/media_library_tab.dart';
import 'tabs/source_library_tab.dart';
import 'tabs/profile_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _pages = [
    MediaLibraryTab(),
    SourceLibraryTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: '媒体库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: '资源库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
} 