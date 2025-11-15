// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter/material.dart';
// import 'package:grape/services/wine_service.dart';
// import 'package:grape/models/wine.dart';
// import 'package:grape/models/wine_marker.dart';

// final wineMapProvider = FutureProvider<List<WineMarker>>((ref) async {
//   // Récupérer la liste des vins depuis le WineService
//   final List<Wine> wines = await WineService(ref).getWinesByLocation();


//   for (var wine in wines) {
//     print('AAAAAAAAAAA - Vin: ${wine.name}, Lat: ${wine.latitude}, Lng: ${wine.longitude}, Location: ${wine.location}');
//   }

//   final Color accent =  Colors.red;

//   // Construire les markers pour chaque vin
//   final List<WineMarker> markers = wines.map((Wine wine) {
//     final Marker marker = Marker(
//       point: LatLng(wine.latitude, wine.longitude),
//       width: 40,
//       height: 40,
//       child: Icon(
//         Icons.local_bar,
//         color: accent,
//         size: 32,
//       ),
//     );

//     return WineMarker(wine: wine, marker: marker);
//   }).toList();

//   return markers;
// });
