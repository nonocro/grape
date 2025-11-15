import 'package:riverpod/riverpod.dart';

final userCountryProvider = StateProvider<String?>((ref) => null);
final userCityAndRegionProvider = StateProvider<String?>((ref) => null);

// Pour la récupération de la localisation une seule fois
final locationFetchedProvider = StateProvider<bool>((ref) => false);
