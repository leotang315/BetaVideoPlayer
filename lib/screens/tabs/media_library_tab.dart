import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/video_source.dart';
import '../../providers/recent_play_provider.dart';
import '../../providers/video_provider.dart';
import '../all_recent_plays_screen.dart';
import '../all_sources_screen.dart';
import '../video_player_screen.dart';

class MediaLibraryTab extends StatelessWidget {
  const MediaLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Row(
            children: [
              Image.asset('assets/logo.webp', height: 32),
              const SizedBox(width: 8),
              const Text('网易爆米花'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: 实现搜索功能
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // TODO: 实现刷新功能
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildRecentlyPlayed(context),
              _buildTVShows(context),
              _buildOthers(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '最近播放',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<RecentPlayProvider>(
                builder: (context, provider, child) {
                  return TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllRecentPlaysScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '全部 ${provider.recentVideos.length} >',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Consumer<RecentPlayProvider>(
            builder: (context, recentPlayProvider, child) {
              if (recentPlayProvider.recentVideos.isEmpty) {
                return Center(
                  child: Text(
                    '暂无播放记录',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentPlayProvider.recentVideos.length,
                itemBuilder: (context, index) {
                  final video = recentPlayProvider.recentVideos[index];
                  return GestureDetector(
                    onTap: () => _playVideo(context, video),
                    child: _buildVideoCard(video),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTVShows(BuildContext context) {
    final shows = [
      {'title': '动物王国大冒险', 'seasons': '共1季', 'rating': null},
      {'title': '开口说英语', 'seasons': '共5季', 'rating': 7.5},
      {'title': '小鼠波波', 'seasons': '共1季', 'rating': 8.8},
      {'title': 'DIDI狗的一天', 'seasons': '共1季', 'rating': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '电视剧',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<VideoProvider>(
                builder: (context, provider, child) {
                  return TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllSourcesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '全部 ${provider.videos.length} >',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index];
              return _buildShowCard(show);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOthers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '其他',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<VideoProvider>(
                builder: (context, provider, child) {
                  // 这里可以根据实际需求计算其他类型的视频数量
                  final otherCount = provider.videos.where((v) => 
                    // 添加其他类型的判断条件
                    true
                  ).length;
                  return TextButton(
                    onPressed: () {
                      // TODO: 查看全部其他内容
                    },
                    child: Text(
                      '全部 $otherCount >',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.movie, size: 48, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(VideoFile video) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.play_circle_outline,
                        size: 48, color: Colors.grey[400]),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '06:22',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            video.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildShowCard(Map<String, dynamic> show) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.movie, size: 48, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            show['title']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                show['seasons']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (show['rating'] != null) ...[
                const SizedBox(width: 8),
                Text(
                  show['rating'].toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _playVideo(BuildContext context, VideoFile video) {
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
  }
}
