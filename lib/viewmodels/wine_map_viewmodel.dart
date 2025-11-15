import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/models/wine_marker.dart';
import 'package:grape/services/wine_service.dart';

class WineMapViewModel extends StateNotifier<AsyncValue<List<WineMarker>>> {
  final Ref ref;
  final List<WineMarker> _cache = [];
  bool _isLoading = false;

  // Contrôle de l'affichage du loader
  bool showLoading = true;

  WineMapViewModel(this.ref) : super(const AsyncValue.data([])) {
    _loadMarkersProgressively();
  }

  Future<void> _loadMarkersProgressively() async {
    if (_isLoading) return;
    _isLoading = true;

    final service = WineService(ref);
    final List<Wine> wines = await service.fetchFilteredWines();

    // On active le loader au début
    showLoading = true;
    state = AsyncValue.data(List.from(_cache));

    for (final wine in wines) {
      try {
        final List<Location> locations = await locationFromAddress(wine.location);
        if (locations.isEmpty) continue;

        final coords = LatLng(locations.first.latitude, locations.first.longitude);
        _cache.add(WineMarker(wine: wine, coords: coords));

        // Mise à jour progressive
        state = AsyncValue.data(List.from(_cache));

        print("Marker ajouté pour ${wine.location}: ${coords.latitude}, ${coords.longitude}");
      } catch (e) {
        print("Erreur géocoding '${wine.location}': $e");
      }
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      showLoading = false;
    });

    _isLoading = false;
  }

  Future<void> refresh() async {
    _cache.clear();
    state = const AsyncValue.data([]);
    showLoading = true;
    _loadMarkersProgressively();
  }
}
