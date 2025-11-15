import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grape/models/wine_marker.dart';
import 'package:grape/providers/location_provider.dart';
import 'package:grape/services/wine.dart';

class WineService {
  final Ref ref;

  WineService(this.ref);

  // Cache local pour aller plus vite
  // List<WineMarker>? _cachedMarkers;
  

  /// Récupère les vins filtrés par localisation et crée des WineMarker avec lat/lng réelles
  Stream<List<WineMarker>> getWinesByLocationStream() async* {

  // if (_cachedMarkers != null && _cachedMarkers!.isNotEmpty) {
  //   yield _cachedMarkers!;
  //   return;
  // }

  final country = ref.watch(userCountryProvider);
  final cityRegion = ref.watch(userCityAndRegionProvider);

  final wines = await fetchRedWines();

  final filteredWines = (country == null || country.isEmpty)
      ? wines
      : wines.where((wine) {
          final loc = wine.location.toLowerCase();
          final countryLower = country.toLowerCase();
          final region = cityRegion?.toLowerCase() ?? '';
          return loc.contains(countryLower) || loc.contains(region);
        }).toList();

  final List<WineMarker> markers = [];

  for (final wine in filteredWines) {
    try {
      final locations = await locationFromAddress(wine.location);

      if (locations.isNotEmpty) {
        final coords = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        markers.add(
          WineMarker(wine: wine, coords: coords),
        );

        // Envoi au fur et à mesure
        yield List.from(markers);
      }
    } catch (e) {
      print("Erreur géocoding : $e");
    }
  }
}


  /// Provider pour la page
 static final winesByLocationProvider =
    StreamProvider<List<WineMarker>>((ref) {
    final service = WineService(ref);
    return service.getWinesByLocationStream();
  });


}
