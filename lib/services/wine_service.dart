import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/providers/location_provider.dart';
import 'package:grape/services/wine.dart';

/// Service pour gérer les vins et filtrer selon la localisation de l’utilisateur
class WineService {
  final Ref ref;

  WineService(this.ref);

  /// Récupère les vins en filtrant par pays/région
  Future<List<Wine>> getWinesByLocation() async {
    final country = ref.watch(userCountryProvider);
    final cityRegion = ref.watch(userCityAndRegionProvider);

    // Tous les vins disponibles
    final wines = await fetchRedWines();

    if (country == null || country.isEmpty) return wines;

    final region = cityRegion?.toLowerCase() ?? '';
    final countryLower = country.toLowerCase();

    // Filtrage
    return wines.where((wine) {
      final loc = wine.location.toLowerCase();
      return loc.contains(countryLower) || loc.contains(region);
    }).toList();
  }

  /// Provider public pour accéder directement à la liste des vins filtrés
  static final winesByLocationProvider =
      FutureProvider.autoDispose<List<Wine>>((ref) async {
    final service = WineService(ref);
    return service.getWinesByLocation();
  });
}
