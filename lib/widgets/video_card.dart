import 'package:beta_player/models/video_source.dart';
import 'package:flutter/material.dart';

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
