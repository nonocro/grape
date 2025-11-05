import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/wine.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/components/homepage/small_wine_card.dart';
import 'package:grape/components/homepage/big_wine_card.dart';
import "dart:math";
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Wine>> _wines;
  String? _userCountry;
  String? _userRegion;
  AppColorsExtension? _theme;

  @override
  void initState() {
    super.initState();
    _wines = fetchRedWines();
    _askLocationAndFetch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context).extension<AppColorsExtension>();
  }

  Future<void> _askLocationAndFetch() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        _wines = fetchRedWines();
      });
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
    String region = (placemarks != null && placemarks.isNotEmpty && placemarks.first.administrativeArea != null)
        ? placemarks.first.administrativeArea!
        : (placemarks != null && placemarks.isNotEmpty && placemarks.first.locality != null)
          ? placemarks.first.locality!
          : '';
    setState(() {
      _userRegion = region;
      _userCountry = country;
      _wines = fetchRedWines();
    });
  }

  List<Wine> filterWines(List<Wine> wines, String? country, String? region) {
    if (country != null && country.isNotEmpty && region != null && region.isNotEmpty) {
      final byCountryAndRegion = wines.where((wine) => wine.location.contains(country) && wine.location.contains(region)).toList();
      if (byCountryAndRegion.isNotEmpty) return byCountryAndRegion;
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: FutureBuilder<List<Wine>>(
        future: _wines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final wines = snapshot.data!;
            var nearWines = filterWines(wines, _userCountry, _userRegion);
            var limitedNearWines = nearWines.take(10).toList();
            var limitedNearWines2 = wines.skip(10).take(10).toList();
            final bestWine = wines[Random().nextInt(wines.length)];

            if (limitedNearWines.isEmpty && limitedNearWines2.isEmpty) {
              nearWines = (_userCountry != null && _userCountry!.isNotEmpty)
                ? wines.where((wine) => wine.location.contains(_userCountry!)).toList()
                : wines;

              limitedNearWines = nearWines.take(10).toList();
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
                            'Vins de ${_userCountry != null && _userCountry!.isNotEmpty ? _userCountry! : 'votre pays'}',
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
          } else {
            return const Center(child: Text('Aucun vin disponible.'));
          }
        },
      ),
    );
  }
}