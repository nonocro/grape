import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/models/wine_marker.dart';
import 'package:grape/viewmodels/wine_map_viewmodel.dart';

final wineMapProvider = StateNotifierProvider<WineMapViewModel, AsyncValue<List<WineMarker>>>(
  (ref) => WineMapViewModel(ref),
);

// Etat pour le chargement de la carte
final wineMapLoadingProvider = StateProvider<bool>((ref) => true);
