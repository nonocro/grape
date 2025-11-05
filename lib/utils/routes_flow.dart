import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

/**
 * Détermine la route à initialisé au début de l'application
 */
Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final bool hasCompletedOnboarding =
      prefs.getBool(kOnboardingCompletedKey) ?? false;
  log("REDIRECT AVEC COMPLETEONBOARDING $kOnboardingCompletedKey");
  return hasCompletedOnboarding ? RouteNames.home : RouteNames.onboarding;
}