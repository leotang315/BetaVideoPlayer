import 'package:beta_player/providers/video_meta_provider.dart';
import 'package:beta_player/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/card_info.dart';

class AllVideoPage extends StatelessWidget {
  AllVideoPage(String category, List<CardInfo> cards)
    : _category = category,
      _cards = cards;

  String _category;
  List<CardInfo> _cards;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_category)),
        // 在手机上使用更紧凑的布局
        toolbarHeight: isTablet ? kToolbarHeight : 45,
      ),
      body: Consumer<VideoMetaProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // 根据屏幕宽度动态计算卡片数量和大小
              final crossAxisCount = isTablet ? 4 : 2;
              final spacing = isTablet ? 12.0 : 8.0;
              
              return GridView.builder(
                padding: EdgeInsets.all(spacing),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 0.6,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return VideoCard(cardInfo: _cards[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
