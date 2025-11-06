import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grape/providers/location_provider.dart';

Future<void> askLocationAndFetch(WidgetRef ref) async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    return;
  }
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  List<Placemark>? placemarks;
  try {
    placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  } catch (e) {
    placemarks = null;
  }
  String country = (placemarks != null && placemarks.isNotEmpty && placemarks.first.country != null)
      ? placemarks.first.country!
      : '';

  String cityAndRegion = (placemarks != null && placemarks.isNotEmpty && placemarks.first.locality != null)
      ? placemarks.first.locality!
      : '';
  ref.read(userCityAndRegionProvider.notifier).state = cityAndRegion;
  ref.read(userCountryProvider.notifier).state = country;
}
