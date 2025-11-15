import 'package:latlong2/latlong.dart';
import 'package:grape/models/wine.dart';

class WineMarker {
  final Wine wine;
  final LatLng coords;

  WineMarker({
    required this.wine,
    required this.coords,
  });
}
