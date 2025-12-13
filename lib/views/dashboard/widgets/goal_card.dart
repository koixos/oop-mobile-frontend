import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final double progress;

  const GoalCard({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;
    final cardHeight = cardWidth * 0.9;
    final imageHeight = cardHeight * 0.45;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF0D241D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/400/200'),
                fit: BoxFit.cover
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            color: const Color(0xFF06D66E),
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Color(0xFF37BF6C)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}