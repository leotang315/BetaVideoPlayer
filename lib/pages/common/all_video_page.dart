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
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(_category))),
      body: Consumer<VideoMetaProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // 每个卡片的宽度不超过 200
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.6,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              return VideoCard(cardInfo: _cards[index]);
            },
          );
        },
      ),
    );
  }
}
