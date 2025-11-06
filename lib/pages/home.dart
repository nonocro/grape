import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/components/homepage/big_wine_card.dart';
import 'package:grape/components/homepage/small_wine_card.dart';
import 'package:grape/providers/location_provider.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/services/location_service.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/models/wine.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  AppColorsExtension? _theme;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context).extension<AppColorsExtension>();
  }

  List<Wine> _filterWines(List<Wine> wines, String? country, String? cityAndRegion) {
    if (country == null || country.isEmpty) return wines;
    final region = cityAndRegion?.toLowerCase() ?? '';
    final countryLower = country.toLowerCase();

    return wines.where((wine) {
      final loc = wine.location.toLowerCase();
      return loc.contains(countryLower) || loc.contains(region);
    }).toList();
  }

  Widget _buildWineSection(String title, List<Wine> wines, {bool bigCard = false}) {
    final accentColor = _theme?.accentColor ?? Colors.amber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        bigCard
            ? BigWineCard(wine: wines[Random().nextInt(wines.length)])
            : SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: wines.length,
                  padding: const EdgeInsets.only(left: 16),
                  itemBuilder: (context, index) {
                    final wine = wines[index];
                    final cardColor = index % 2 == 0
                        ? accentColor
                        : _theme?.cardColor ?? Colors.white;
                    final textColor = index % 2 == 0 ? Colors.black : Colors.white;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SmallWineCard(
                        wine: wine,
                        cardColor: cardColor,
                        textColor: textColor,
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _theme?.backgroundColor ?? Colors.white;
    final wineListAsync = ref.watch(wineListProvider);
    final userCountry = ref.watch(userCountryProvider);
    final userCityAndRegion = ref.watch(userCityAndRegionProvider);

    // Assure la récupération de la localisation au premier build
    final locationFetched = ref.watch(locationFetchedProvider);

    if (!locationFetched) {
      Future.microtask(() async {
        await ref.read(locationServiceProvider).fetchUserLocation();
        ref.read(locationFetchedProvider.notifier).state = true;
    });
}

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: wineListAsync.when(
        data: (wines) {
          final nearWines = _filterWines(wines, userCountry, userCityAndRegion);
          final limitedNearWines = nearWines.take(10).toList();
          final limitedNearWines2 = wines.skip(10).take(10).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (limitedNearWines.isNotEmpty)
                  _buildWineSection('Notre sélection', limitedNearWines, bigCard: true),
                _buildWineSection('Vins de chez vous', limitedNearWines),
                _buildWineSection('Découvrez', limitedNearWines2),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
      ),
    );
  }
}
