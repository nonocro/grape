import 'package:flutter/material.dart';

// Constantes pour SharedPreferences
const String kOnboardingCompletedKey = 'onboarding_completed';

// Noms de vos routes (pour éviter les erreurs de frappe)
class RouteNames {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
}

// Couleurs (si elles ne font pas partie du système de ThemeData)
const Color kBackgroundColor = Color(0xFFFAFAFA);
const Color kAccentColor = Color(0xFFE5C65D);

// Styles de Texte (Exemple)
const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);