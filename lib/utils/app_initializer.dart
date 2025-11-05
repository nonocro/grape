// lib/utils/app_initializer.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import '../services/wine.dart';

class AppInitializer {
  
  /// Charge les données initiales de l'app
  static Future<void> loadData() async {
    await fetchRedWines();
  }

  /// Détermine la route à afficher après le Splash
  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasCompletedOnboarding =
        prefs.getBool(kOnboardingCompletedKey) ?? false;
    return hasCompletedOnboarding ? RouteNames.home : RouteNames.onboarding;
  }
}
