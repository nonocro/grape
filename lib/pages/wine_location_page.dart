import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/wine_map_service.dart';
import 'package:grape/services/location_service.dart';

class WineLocationPage extends ConsumerStatefulWidget {
  const WineLocationPage({super.key});

  @override
  ConsumerState<WineLocationPage> createState() => _WineLocationPageState();
}

class _WineLocationPageState extends ConsumerState<WineLocationPage> {
  bool _mapReady = false;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Déclencher l'affichage de la map d'abord
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _mapReady = true);
    });

    // Lancer la localisation de l'utilisateur
    ref.read(locationServiceProvider).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        Theme.of(context).extension<AppColorsExtension>()?.accentColor ??
            Colors.red;

    // On ne regarde le provider que si la map est prête
    final wineMarkersAsync = _mapReady
        ? ref.watch(wineMapProvider) // provider qui renvoie List<WineMarker>
        : const AsyncValue.loading();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vins près de chez vous"),
        backgroundColor: accent,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(46.5, 2.0), // centre de la France
          initialZoom: 5.5,
          minZoom: 3,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.grape',
          ),

          // Affichage des markers
          wineMarkersAsync.when(
            data: (wineMarkers) => MarkerLayer(
              markers: wineMarkers.map((wm) => wm.marker).toList(),
            ),
            loading: () => const MarkerLayer(markers: []),
            error: (err, stack) => const MarkerLayer(markers: []),
          ),
        ],
      ),
    );
  }
}