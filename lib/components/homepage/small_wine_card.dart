import 'package:flutter/material.dart';
import 'package:grape/models/wine.dart';

class SmallWineCard extends StatelessWidget {
  final Wine wine;
  final Color cardColor;
  final Color textColor;
  const SmallWineCard({super.key, required this.wine, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(30)),
            ),
          ),
          Positioned(
            top: 10,
            child: Image.network(
              wine.image,
              height: 200,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 8,
            right: 8,
            child: Builder(builder: (context) {
              final name = wine.name;
              const int headCount = 16;
              const int tailCount = 6;
              String displayName = name;
              if (name.length > headCount + tailCount + 3) {
                displayName = '${name.substring(0, headCount)}\n...${name.substring(name.length - tailCount)}';
              }
              return Text(
                displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}