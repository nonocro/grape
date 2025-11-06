import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grape/models/wine_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/services/wine_service.dart';

/// Provider qui retourne les markers pour la carte
final wineMapProvider = FutureProvider<List<WineMarker>>((ref) async {
  final wines = await WineService(ref).getWinesByLocation();

  final accent = Colors.red; // ou depuis ton thème

  final wineMarkers = wines.map((wine) {
    final marker = Marker(
      point: LatLng(wine.latitude, wine.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
          // showDialog ici
        },
        child: Icon(Icons.local_bar, color: accent, size: 32),
      ),
    );
    return WineMarker(wine: wine, marker: marker);
  }).toList();

  return wineMarkers;
});
