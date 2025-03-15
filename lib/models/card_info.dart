import 'package:beta_player/models/video_meta.dart';

class CardInfo {
  final String title;
  final String subtitle;
  final String imgPath;
  final double score;
  final VideoMetadata meta;
  CardInfo({
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.score,
    required this.meta,
  });
}
