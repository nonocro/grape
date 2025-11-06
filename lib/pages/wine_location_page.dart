import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/services/wine.dart';
import 'package:grape/components/homepage/small_wine_card.dart';
import 'package:grape/theme/app_colors_extension.dart';

class WineLocationPage extends StatefulWidget {
  const WineLocationPage({super.key});

  @override
  State<WineLocationPage> createState() => _WineLocationPageState();
}

class _WineLocationPageState extends State<WineLocationPage> {
  late Future<List<Wine>> _winesFuture;
  String? _userCountry;
  String? _userRegion;

  @override
  void initState() {
    super.initState();
    _winesFuture = _loadData();
  }

  Future<List<Wine>> _loadData() async {
    await _getLocation();
    return fetchRedWines();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _userCountry = null;
      _userRegion = null;
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      _userCountry = place.country;
      _userRegion = place.administrativeArea ?? place.locality;
    }
  }

  List<Wine> _filterByLocation(List<Wine> wines) {
    if (_userCountry == null) return wines;

    final region = _userRegion?.toLowerCase() ?? '';
    final country = _userCountry!.toLowerCase();

    // On filtre par pays, puis par région si dispo
    return wines.where((wine) {
      final loc = wine.location.toLowerCase();
      return loc.contains(country) || loc.contains(region);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final accent = colors?.accentColor ?? Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: colors?.backgroundColor ?? Colors.white,
      appBar: AppBar(
        title: const Text("Vins près de chez vous"),
        backgroundColor: accent,
      ),
      body: FutureBuilder<List<Wine>>(
        future: _winesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final wines = snapshot.data ?? [];
          final localWines = _filterByLocation(wines);

          if (localWines.isEmpty) {
            return const Center(
              child: Text("Aucun vin trouvé près de votre position."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: localWines.length,
            itemBuilder: (context, index) {
              final wine = localWines[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SmallWineCard(
                  wine: wine,
                  cardColor: accent,
                  textColor: Colors.black,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
