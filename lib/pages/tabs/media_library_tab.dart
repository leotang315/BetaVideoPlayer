import 'package:beta_player/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../../models/video_source1b.dart';
import '../../providers/recent_play_provider.dart';
import '../../providers/video_provider.dart';
import '../common/video_player_page.dart';
import '../common/all_recent_plays_screen.dart';
import '../common/all_video_page.dart';

class MediaLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Row(children: [Image.asset('assets/logo.webp', height: 32)]),
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
              _buildRecentPlaysSection(context),
              _buildMoviesSection(context),
              _buildTVShowsSection(context),
              _buildOtherSection(context),
            ],
          ),
        ),
      ],
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
                onPressed:
                    () => Navigator.push(
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
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: true,
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: Scrollbar(
                  thickness: 6.0,
                  radius: Radius.circular(3.0),
                  thumbVisibility: true,
                  interactive: true,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.limitedRecentPlays.length,
                    itemBuilder: (context, index) {
                      final video = provider.limitedRecentPlays[index];
                      return SizedBox(
                        width: 200,
                        child: _buildMoviesSection(context),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoviesSection(BuildContext context) {
    final show2 = [
      CardInfo(
        title: '动物王国大冒险',
        subtitle: '共2季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: '开口说英语',
        subtitle: '共5季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
      CardInfo(
        title: '小鼠波波',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: 'DIDI狗的一天',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
    ];
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return _buildSection(context, '电影', show2);
      },
    );
  }

  Widget _buildTVShowsSection(BuildContext context) {
    final show2 = [
      CardInfo(
        title: '动物王国大冒险',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: '开口说英语',
        subtitle: '共5季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
      CardInfo(
        title: '小鼠波波',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: 'DIDI狗的一天',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
      CardInfo(
        title: 'DIDI狗的2天',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
    ];
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return _buildSection(context, '电视剧', show2);
      },
    );
  }

  Widget _buildOtherSection(BuildContext context) {
    final show2 = [
      CardInfo(
        title: '动物王国大冒险',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: '开口说英语',
        subtitle: '共5季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
      CardInfo(
        title: '小鼠波波',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 7.5,
      ),
      CardInfo(
        title: 'DIDI狗的一天',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
      CardInfo(
        title: 'DIDI狗的2天',
        subtitle: '共1季',
        imgPath: 'assets/logo.webp',
        score: 8.8,
      ),
    ];
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return _buildSection(context, '其他', show2);
      },
    );
  }

  Widget _buildSection(
    BuildContext context,
    String category,
    List<CardInfo> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllVideoPage(category, cards),
                    ),
                  );
                },
                child: Text(
                  '全部 ${cards.length} >',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: true,
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return VideoCard(cards[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildSourcesSection(BuildContext context) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('媒体库', style: TextStyle(fontSize: 18)),
  //             TextButton(
  //               onPressed:
  //                   () => Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (_) => AllSourcesScreen()),
  //                   ),
  //               child: Text('全部'),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Consumer<VideoProvider>(
  //         builder: (context, provider, child) {
  //           if (provider.videos.isEmpty) {
  //             return Center(child: Text('暂无媒体库'));
  //           }
  //           return ListView.builder(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemCount: provider.videos.length.clamp(0, 3),
  //             itemBuilder: (context, index) {
  //               final source = provider.videos[index];
  //               return ListTile(
  //                 leading: Icon(_getSourceIcon(source.type)),
  //                 title: Text(source.name),
  //                 subtitle: Text('${source.playlist.length} 个视频'),
  //                 onTap: () {
  //                   provider.setCurrentVideo(source);
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => VideoPlayerScreen(),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildVideoCard(BuildContext context, VideoFile video) {
  //   return Card(
  //     margin: EdgeInsets.all(8),
  //     child: InkWell(
  //       onTap: () {
  //         // 处理视频播放
  //       },
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             width: 160,
  //             height: 120,
  //             color: Colors.grey[800],
  //             child: Icon(Icons.play_circle_outline, size: 48),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(8),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   video.name,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // IconData _getSourceIcon(SourceType type) {
  //   switch (type) {
  //     case SourceType.local:
  //       return Icons.folder;
  //     case SourceType.smb:
  //       return Icons.computer;
  //     case SourceType.webdav:
  //       return Icons.cloud;
  //   }
  // }
}
