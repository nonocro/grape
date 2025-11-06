import 'package:flutter_map/flutter_map.dart';
import 'package:grape/models/wine.dart';

class WineMarker {
  final Wine wine;
  final Marker marker;

  WineMarker({required this.wine, required this.marker});
}
