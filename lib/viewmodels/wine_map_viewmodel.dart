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

  WineMapViewModel(this.ref) : super(const AsyncValue.data([])) {
    _loadMarkersProgressively();
  }

  Future<void> _loadMarkersProgressively() async {
    if (_isLoading) return;
    _isLoading = true;

    final service = WineService(ref);
    final List<Wine> wines = await service.fetchFilteredWines();

    for (var wine in wines) {
      try {
        final List<Location> locations = await locationFromAddress(wine.location);
        if (locations.isEmpty) continue;

        final coords = LatLng(locations.first.latitude, locations.first.longitude);
        final wineMarker = WineMarker(wine: wine, coords: coords);

        _cache.add(wineMarker);
        print("Marker ajouté : ${wine.name} => ${coords.latitude}, ${coords.longitude}");
        state = AsyncValue.data(List.from(_cache));

      } catch (e) {
        print("Erreur géocoding '${wine.location}': $e");
      }
    }

    _isLoading = false;
  }


  // Rafraîchir les markers
  Future<void> refresh() async {
    _cache.clear();
    state = const AsyncValue.data([]);
    _loadMarkersProgressively();
  }
}
