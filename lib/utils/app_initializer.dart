// lib/utils/app_initializer.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:grape/pages/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import '../services/wine.dart';

class AppInitializer {
  
  /// Charge les données initiales de l'app
  static Future<void> loadData() async {
    await fetchRedWines();
  }

  /// Détermine la route à afficher après le Splash
  static Future<String> getInitialRoute({
    required SharedPreferences prefs,
    required FirebaseAuth auth,
  }) async {
    final hasCompletedOnboarding =
        prefs.getBool(kOnboardingCompletedKey) ?? false;

    if (!hasCompletedOnboarding) return RouteNames.onboarding;
    return RouteNames.auth;
  }
}
