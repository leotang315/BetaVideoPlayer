import 'dart:io';

import 'package:flutter/material.dart';

import '../models/card_info.dart';
import '../services/image_cache_service.dart';

class VideoCard extends StatelessWidget {
  final CardInfo cardInfo;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final bool showScore;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const VideoCard({
    super.key,
    required this.cardInfo,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin = const EdgeInsets.all(8.0),
    this.showScore = true,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    final defaultSubtitleStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPosterImage()),
          const SizedBox(height: 8),
          Text(
            cardInfo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ?? defaultTitleStyle,
          ),
          const SizedBox(height: 4),
          Text(
            cardInfo.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: subtitleStyle ?? defaultSubtitleStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildPosterImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: FutureBuilder<String>(
              future: ImageCacheService().getCachedImagePath(cardInfo.imgPath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                }
                return Image.file(File(snapshot.data!), fit: BoxFit.cover);
              },
            ),
          ),
        ),
        if (showScore && cardInfo.score > 0)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    cardInfo.score.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
