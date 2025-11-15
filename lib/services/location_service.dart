import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grape/providers/location_provider.dart';


class LocationService {
  final Ref ref;

  LocationService(this.ref);

  /// Demande la permission et récupère la localisation
  Future<void> fetchUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Reset si refusé
      ref.read(userCountryProvider.notifier).state = null;
      ref.read(userCityAndRegionProvider.notifier).state = null;
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );

    List<Placemark>? placemarks;
    try {
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      placemarks = null;
    }

    final country =
        placemarks != null && placemarks.isNotEmpty && placemarks.first.country != null
            ? placemarks.first.country!
            : null;

    final cityAndRegion =
        placemarks != null && placemarks.isNotEmpty && placemarks.first.locality != null
            ? placemarks.first.locality!
            : null;

    ref.read(userCountryProvider.notifier).state = country;
    ref.read(userCityAndRegionProvider.notifier).state = cityAndRegion;
  }
}

// Provider pour exposer LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref);
});
