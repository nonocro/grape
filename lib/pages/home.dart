import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/providers/location_provider.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/services/location_service.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/wine.dart';
import 'package:grape/components/homepage/small_wine_card.dart';
import 'package:grape/components/homepage/big_wine_card.dart';
import "dart:math";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  AppColorsExtension? _theme;

  @override
  void initState() {
    super.initState();
    askLocationAndFetch(ref);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context).extension<AppColorsExtension>();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _theme?.backgroundColor ?? Colors.white;
    final wineList = ref.watch(wineListProvider);
    final userCountry = ref.watch(userCountryProvider);
    final userCityAndRegion = ref.watch(userCityAndRegionProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: wineList.when(
        data: (wines) {
            final nearWines = filterWines(wines, userCountry, userCityAndRegion);
            var limitedNearWines = nearWines.take(10).toList();
            var limitedNearWines2 = wines.skip(10).take(10).toList();
            final bestWine = wines[Random().nextInt(wines.length)];

            if (limitedNearWines.isEmpty && limitedNearWines2.isEmpty) {
              final filteredWines = (userCountry != null && userCountry.isNotEmpty)
                ? wines.where((wine) => wine.location.contains(userCountry)).toList()
                : wines;

              limitedNearWines = filteredWines.take(10).toList();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (limitedNearWines.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Notre sélection',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BigWineCard(wine: bestWine),
                  ],
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Vins de chez vous',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement navigation to full wine list page
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View all',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: limitedNearWines.length,
                        itemBuilder: (context, index) {
                          final wine = limitedNearWines[index];
                          final cardColor = index % 2 == 0
                              ? _theme?.accentColor ?? Colors.amber
                              : _theme?.cardColor ?? Colors.white;
                          final textColor = index % 2 == 0
                              ? Colors.black
                              : Colors.white;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SmallWineCard(wine: wine, cardColor: cardColor, textColor: textColor),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Découvrez',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement navigation to full wine list page
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View all',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: limitedNearWines2.length,
                        itemBuilder: (context, index) {
                          final wine = limitedNearWines2[index];
                          final cardColor = index % 2 == 0
                              ? _theme?.accentColor ?? Colors.amber
                              : _theme?.cardColor ?? Colors.white;
                          final textColor = index % 2 == 0
                              ? Colors.black
                              : Colors.white;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SmallWineCard(wine: wine, cardColor: cardColor, textColor: textColor),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erreur: $error')),
      ),
    );
  }
}
