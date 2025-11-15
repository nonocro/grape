import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/models/wine.dart';
import 'package:grape/providers/location_provider.dart';
import 'package:grape/services/wine.dart';

class WineService {
  final Ref ref;

  WineService(this.ref);

  Future<List<Wine>> fetchFilteredWines() async {
    final String? country = ref.watch(userCountryProvider);
    final String? cityRegion = ref.watch(userCityAndRegionProvider);

    final wines = await fetchRedWines();

    if (country == null || country.isEmpty) {
      return wines;
    }

    final c = country.toLowerCase();
    final r = (cityRegion ?? '').toLowerCase();

    return wines.where((w) {
      final loc = w.location.toLowerCase();
      return loc.contains(c) || loc.contains(r);
    }).toList();
  }
}
