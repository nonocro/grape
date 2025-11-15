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

  // Texte de recherche
  String _searchQuery = '';
  // Contrôle de l'affichage du loader
  bool showLoading = true;

  WineMapViewModel(this.ref) : super(const AsyncValue.data([])) {
    _loadMarkersProgressively();
  }

  /// Met à jour la recherche
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
  }

  /// Applique le filtre sur les markers déjà chargés
  void _applyFilter() {
    final filtered = _cache.where((wm) {
      final wineName = wm.wine.name.toLowerCase();
      final winery = wm.wine.winery.toLowerCase();
      final location = wm.wine.location.toLowerCase();
      return wineName.contains(_searchQuery) ||
             winery.contains(_searchQuery) ||
             location.contains(_searchQuery);
    }).toList();

    state = AsyncValue.data(filtered);
  }

  /// Charge les markers progressivement
  Future<void> _loadMarkersProgressively() async {
    if (_isLoading) return;
    _isLoading = true;
    showLoading = true;


    final service = WineService(ref);
    final List<Wine> wines = await service.fetchFilteredWines();

    for (final wine in wines) {
      try {
        final List<Location> locations = await locationFromAddress(wine.location);
        if (locations.isEmpty) continue;

        final coords = LatLng(locations.first.latitude, locations.first.longitude);
        _cache.add(WineMarker(wine: wine, coords: coords));

        // Mise à jour progressive avec filtrage
        _applyFilter();


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

  /// Rafraîchir les markers et reset la recherche
  Future<void> refresh() async {
    _cache.clear();
    state = const AsyncValue.data([]);
    showLoading = true;
    _loadMarkersProgressively();
  }
}
