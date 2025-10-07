import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wine.dart';

class WineStorageService {
  static const String _wineKey = 'wine_of_the_day';

  /// Sauvegarde l'id du vin du jour dans le stockage local
  Future<void> saveWineOfTheDay(int wineId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_wineKey, wineId);
  }

  /// Récupère l'id du vin sauvegardé depuis le stockage local
  Future<int?> getWineOfTheDayId() async {
    final prefs = await SharedPreferences.getInstance();
    final wineId = prefs.getInt(_wineKey);

    if (wineId == null) return null;

    return wineId;
  }

  /// Supprime le vin sauvegardé
  Future<void> clearWineOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wineKey);
  }
}
