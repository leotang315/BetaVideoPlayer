import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recent_play_provider.dart';
import '../providers/video_provider.dart';
import '../screens/video_player_screen.dart';

class AllRecentPlaysScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('播放历史'),
      ),
      body: Consumer<RecentPlayProvider>(
        builder: (context, provider, child) {
          if (provider.recentPlays.isEmpty) {
            return Center(child: Text('暂无播放记录'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.recentPlays.length,
            itemBuilder: (context, index) {
              final video = provider.recentPlays[index];
              final color = Colors.primaries[video.hashCode % Colors.primaries.length];
              
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    // 查找视频所属的 VideoSource
                    final videoProvider = context.read<VideoProvider>();
                    for (var source in videoProvider.videos) {
                      int idx = source.playlist.indexWhere((v) => v.path == video.path);
                      if (idx != -1) {
                        source.currentIndex = idx;
                        videoProvider.setCurrentVideo(source);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(),
                          ),
                        );
                        break;
                      }
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.7),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '最近播放',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 