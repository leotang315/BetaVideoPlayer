import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recent_play_provider.dart';
import '../../providers/video_provider.dart';
import '../video_player_screen.dart';
import '../all_recent_plays_screen.dart';
import '../all_sources_screen.dart';
import '../../models/video_source.dart';
class MediaLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('媒体库'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildRecentPlaysSection(context),
                _buildSourcesSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPlaysSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('最近播放', style: TextStyle(fontSize: 18)),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AllRecentPlaysScreen()),
                ),
                child: Text('全部'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Consumer<RecentPlayProvider>(
            builder: (context, provider, child) {
              if (provider.limitedRecentPlays.isEmpty) {
                return Center(child: Text('暂无播放记录'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.limitedRecentPlays.length,
                itemBuilder: (context, index) {
                  final video = provider.limitedRecentPlays[index];
                  return _buildVideoCard(context, video);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSourcesSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('媒体库', style: TextStyle(fontSize: 18)),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AllSourcesScreen()),
                ),
                child: Text('全部'),
              ),
            ],
          ),
        ),
        Consumer<VideoProvider>(
          builder: (context, provider, child) {
            if (provider.videos.isEmpty) {
              return Center(child: Text('暂无媒体库'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.videos.length.clamp(0, 3),
              itemBuilder: (context, index) {
                final source = provider.videos[index];
                return ListTile(
                  leading: Icon(_getSourceIcon(source.type)),
                  title: Text(source.name),
                  subtitle: Text('${source.playlist.length} 个视频'),
                  onTap: () {
                    provider.setCurrentVideo(source);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoFile video) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // 处理视频播放
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 120,
              color: Colors.grey[800],
              child: Icon(Icons.play_circle_outline, size: 48),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSourceIcon(SourceType type) {
    switch (type) {
      case SourceType.local:
        return Icons.folder;
      case SourceType.smb:
        return Icons.computer;
      case SourceType.webdav:
        return Icons.cloud;
    }
  }
}