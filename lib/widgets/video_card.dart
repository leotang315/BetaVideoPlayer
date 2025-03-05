import 'dart:io';

import 'package:flutter/material.dart';

import '../models/video_sot.dart';

class VideoCard extends StatelessWidget {
  final CardInfo cardInfo;

  const VideoCard(this.cardInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      color: Colors.red,
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
                  child: Center(child: Image.file(File(cardInfo.imgPath))),
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
