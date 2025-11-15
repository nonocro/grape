import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/services/location_service.dart';
import 'package:grape/models/wine_marker.dart';
import 'package:grape/providers/wine_map_provider.dart';

class WineLocationPage extends ConsumerStatefulWidget {
  const WineLocationPage({super.key});

  @override
  ConsumerState<WineLocationPage> createState() => _WineLocationPageState();
}

class _WineLocationPageState extends ConsumerState<WineLocationPage> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Lancer la localisation utilisateur
    ref.read(locationServiceProvider).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent =
        Theme.of(context).extension<AppColorsExtension>()?.accentColor ??
        Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vins près de chez vous"),
        backgroundColor: accent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(wineMapProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final AsyncValue<List<WineMarker>> wineMarkersAsync = ref.watch(
            wineMapProvider,
          );

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(46.5, 2.0),
                  initialZoom: 5.5,
                  minZoom: 3,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.grape',
                  ),
                  wineMarkersAsync.when(
                    data: (markers) {
                      final List<Marker> flutterMarkers = markers.map((wm) {
                        return Marker(
                          point: wm.coords,
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(wm.wine.name),
                                  content: Text(
                                    "Vignoble: ${wm.wine.winery}\nLocalisation: ${wm.wine.location}",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Fermer"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              Icons.local_bar,
                              color: accent,
                              size: 32,
                            ),
                          ),
                        );
                      }).toList();

                      return MarkerLayer(markers: flutterMarkers);
                    },
                    loading: () => const MarkerLayer(markers: []),
                    error: (err, _) => MarkerLayer(markers: []),
                  ),
                ],
              ),

              // Indicateur de chargement progressif
              Consumer(
                builder: (context, ref, _) {
                  final vm = ref.watch(wineMapProvider.notifier);
                  if (!vm.showLoading) return const SizedBox.shrink();

                  return Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Chargement des vins...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
