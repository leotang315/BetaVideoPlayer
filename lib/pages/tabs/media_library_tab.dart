import 'package:beta_player/providers/video_source_provider.dart';
import 'package:beta_player/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../../models/card_info.dart';
import '../../models/video_meta.dart';
import '../../providers/recent_play_provider.dart';
import '../../providers/video_meta_provider.dart';
import '../../services/scraper_manager.dart';
import '../common/video_player_page.dart';
import '../common/all_recent_plays_screen.dart';
import '../common/all_video_page.dart';
import '../../models/play_list.dart';

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
              onPressed: () async {
                // TODO: 实现刷新功能

                final videoSources =
                    context.read<VideoSourceProvider>().videoSources;
                final metaProvider = context.read<VideoMetaProvider>();
                final scraperManager = ScraperManager();
                final metas = await scraperManager.scrapeAllSource(
                  videoSources,
                );
                if (metas != null) {
                  // 清空元数据
                  await metaProvider.clear();
                  await metaProvider.addMetadataList(metas);
                }
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
    final ScrollController _scrollController = ScrollController();
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
                  controller: _scrollController,
                  thickness: 6.0,
                  radius: Radius.circular(3.0),
                  thumbVisibility: true,
                  interactive: true,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    controller: _scrollController,
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
        meta: MovieMetadata(
          name: '动物王国大冒险',
          releaseDate: '2023',
          posterUrl: 'assets/logo.webp',
          rating: 7.5,
          overview: '',
        ),
      ),
      // CardInfo(
      //   title: '开口说英语',
      //   subtitle: '共5季',
      //   imgPath: 'assets/logo.webp',
      //   score: 8.8,
      // ),
      // CardInfo(
      //   title: '小鼠波波',
      //   subtitle: '共1季',
      //   imgPath: 'assets/logo.webp',
      //   score: 7.5,
      // ),
      // CardInfo(
      //   title: 'DIDI狗的一天',
      //   subtitle: '共1季',
      //   imgPath: 'assets/logo.webp',
      //   score: 8.8,
      // ),
    ];
    return Consumer<VideoMetaProvider>(
      builder: (context, provider, child) {
        final movies =
            provider.getMetadataByType(VideoType.movie) as List<MovieMetadata>;
        final cards =
            movies
                .map(
                  (movie) => CardInfo(
                    title: movie.name,
                    subtitle: movie.releaseDate,
                    imgPath: movie.posterUrl,
                    score: movie.rating,
                    meta: movie,
                  ),
                )
                .toList();

        return _buildSection(context, '电影', cards);
      },
    );
  }

  Widget _buildTVShowsSection(BuildContext context) {
    // final show2 = [
    //   CardInfo(
    //     title: '动物王国大冒险',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 7.5,
    //   ),
    //   CardInfo(
    //     title: '开口说英语',
    //     subtitle: '共5季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    //   CardInfo(
    //     title: '小鼠波波',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 7.5,
    //   ),
    //   CardInfo(
    //     title: 'DIDI狗的一天',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    //   CardInfo(
    //     title: 'DIDI狗的2天',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    // ];
    return Consumer<VideoMetaProvider>(
      builder: (context, provider, child) {
        final tvshows =
            provider.getMetadataByType(VideoType.tvShow)
                as List<TVShowMetadata>;
        final cards =
            tvshows
                .map(
                  (tvshow) => CardInfo(
                    title: tvshow.name,
                    subtitle: "共${tvshow.seasons.length}季",
                    imgPath: tvshow.posterUrl,
                    score: tvshow.rating,
                    meta: tvshow,
                  ),
                )
                .toList();

        return _buildSection(context, '电视剧', cards);
      },
    );
  }

  Widget _buildOtherSection(BuildContext context) {
    // final show2 = [
    //   CardInfo(
    //     title: '动物王国大冒险',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 7.5,
    //   ),
    //   CardInfo(
    //     title: '开口说英语',
    //     subtitle: '共5季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    //   CardInfo(
    //     title: '小鼠波波',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 7.5,
    //   ),
    //   CardInfo(
    //     title: 'DIDI狗的一天',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    //   CardInfo(
    //     title: 'DIDI狗的2天',
    //     subtitle: '共1季',
    //     imgPath: 'assets/logo.webp',
    //     score: 8.8,
    //   ),
    // ];
    return Consumer<VideoMetaProvider>(
      builder: (context, provider, child) {
        final others = provider.getMetadataByType(VideoType.other);
        final cards =
            others
                .map(
                  (other) => CardInfo(
                    title: other.name,
                    subtitle: "todo",
                    imgPath: other.posterUrl,
                    score: other.rating,
                    meta: other,
                  ),
                )
                .toList();
        return _buildSection(context, '其他', cards);
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return VideoCard(
                cardInfo: cards[index],
                width: 150,
                borderRadius: 5,
                showScore: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VideoPlayerPage(
                            playlist: PlayList.fromVideoMeta(cards[index].meta),
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
