import 'dart:io';

import 'package:flutter/material.dart';

import '../models/card_info.dart';
import '../services/image_cache_service.dart';

class VideoCard extends StatelessWidget {
  final CardInfo cardInfo;

  const VideoCard(this.cardInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,

      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FutureBuilder<String>(
                    future: ImageCacheService().getCachedImagePath(
                      cardInfo.imgPath,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error));
                      }
                      return Center(
                        child: Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text(cardInfo.score.toString()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cardInfo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            cardInfo.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
