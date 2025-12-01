import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/components/homepage/small_wine_card.dart';
import 'package:grape/components/homepage/big_wine_card.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/providers/location_provider.dart';
import "dart:math";
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    _askLocationAndFetch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context).extension<AppColorsExtension>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _askLocationAndFetch() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark>? placemarks;
    try {
      placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      placemarks = null;
    }
    String country = (placemarks != null && placemarks.isNotEmpty && placemarks.first.country != null)
        ? placemarks.first.country!
        : '';

    String cityAndRegion = (placemarks != null && placemarks.isNotEmpty && placemarks.first.locality != null)
        ? placemarks.first.locality!
        : '';
    
    if (mounted) {
      ref.read(userCountryProvider.notifier).state = country;
      ref.read(userCityAndRegionProvider.notifier).state = cityAndRegion;
    }
  }

  List<Wine> filterWines(List<Wine> wines, String? country, String? cityAndRegion) {
    if (cityAndRegion != null && cityAndRegion.isNotEmpty) {
      final byCityOrRegion = wines.where((wine) => wine.location.contains(cityAndRegion)).toList();
      if (byCityOrRegion.isNotEmpty) return byCityOrRegion;
    }
    if (country != null && country.isNotEmpty) {
      final byCountry = wines.where((wine) => wine.location.contains(country)).toList();
      if (byCountry.isNotEmpty) return byCountry;
    }
    return wines;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _theme?.backgroundColor ?? Colors.white;
    final winesAsync = ref.watch(wineListProvider);
    final userCountry = ref.watch(userCountryProvider);
    final userCityAndRegion = ref.watch(userCityAndRegionProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: _theme?.accentColor ?? Colors.black26,
        elevation: 0,
        title: const Text(
          'Accueil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: winesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (wines) {
            var nearWines = filterWines(wines, userCountry, userCityAndRegion);
            var limitedNearWines = nearWines.take(10).toList();
            var limitedNearWines2 = wines.skip(10).take(10).toList();
            final bestWine = wines[Random().nextInt(wines.length)];

            if (limitedNearWines.isEmpty && limitedNearWines2.isEmpty) {
              nearWines = (userCountry != null && userCountry.isNotEmpty)
                ? wines.where((wine) => wine.location.contains(userCountry)).toList()
                : wines;

              limitedNearWines = nearWines.take(10).toList();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 30, bottom: 32),
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
                    BigWineCard(wine: bestWine, cardColor: _theme!.cardColor, textColor: Colors.white),
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
                              Text(
                                'View all',
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
                              Text(
                                'View all',
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
      ),
    );
  }
}
