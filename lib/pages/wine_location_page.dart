import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/location_service.dart';
import 'package:grape/services/wine_service.dart';
import 'package:grape/models/wine_marker.dart';

class WineLocationPage extends ConsumerStatefulWidget {
  const WineLocationPage({super.key});

  @override
  ConsumerState<WineLocationPage> createState() => _WineLocationPageState();
}

class _WineLocationPageState extends ConsumerState<WineLocationPage> {
  late final MapController _mapController;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Afficher d'abord la carte, puis charger les markers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _mapReady = true);
    });

    // Lancer la localisation de l'utilisateur
    ref.read(locationServiceProvider).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent =
        Theme.of(context).extension<AppColorsExtension>()?.accentColor ?? Colors.red;

    // AsyncValue pour la liste de WineMarker
    final AsyncValue<List<WineMarker>> wineMarkersAsync = _mapReady
        ? ref.watch(WineService.winesByLocationProvider)
        : const AsyncValue.loading();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vins près de chez vous"),
        backgroundColor: accent,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(46.5, 2.0), // centre France
          initialZoom: 5.5,
          minZoom: 3,
          maxZoom: 18,
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.grape',
          ),
          wineMarkersAsync.when(
            data: (List<WineMarker> wines) {
              final markers = wines.map((wineMarker) {
                return Marker(
                  point: wineMarker.coords,
                  width: 45,
                  height: 45,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(wineMarker.wine.name),
                          content: Text(wineMarker.wine.location),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                );
              }).toList();

              return MarkerLayer(markers: markers);
            },
            loading: () => const MarkerLayer(markers: []),
            error: (_, __) => const MarkerLayer(markers: []),
          ),
        ],
      ),
    );
  }
}
