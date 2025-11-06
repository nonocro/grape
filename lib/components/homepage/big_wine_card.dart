import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/pages/wine_details.dart';

class BigWineCard extends StatelessWidget {
  final Wine wine;
  const BigWineCard({required this.wine, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineDetailsPage(wine: wine),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppColorsExtension>()?.cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(16)),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding:  EdgeInsets.all(16.0)),
                      Text(
                        wine.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wine.winery,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wine.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Note: ${wine.rating.average} (${wine.rating.reviews})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    wine.image,
                    width: 80,
                    height: 200,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
