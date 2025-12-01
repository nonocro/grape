import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wine.dart';

class WineStorageService {
  static const String _wineKey = 'wine_of_the_day';
  static const String _dateKey = 'wine_date';
  static const String _historyKey = 'wine_history';

  // Sauvegarder le vin du jour
  Future<void> saveWineOfTheDay(Wine wine) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();

    final wineJson = jsonEncode({
      'id': wine.id,
      'winery': wine.winery,
      'wine': wine.name,
      'location': wine.location,
      'image': wine.image,
      'rating': {
        'average': wine.rating.average,
        'reviews': wine.rating.reviews,
      },
    });

    await prefs.setString(_wineKey, wineJson);
    await prefs.setString(_dateKey, DateTime(today.year, today.month, today.day).toIso8601String());
    await addWineToHistory(wine.id);
  }

  // Récupérer le vin du jour si c'est bien pour aujourd'hui
  Future<Wine?> getWineOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final wineString = prefs.getString(_wineKey);
    final savedDateString = prefs.getString(_dateKey);

    if (wineString == null || savedDateString == null) return null;

    final savedDate = DateTime.parse(savedDateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    //final test = DateTime(2025, 11, 20);

    if (savedDate != today) {
      // Nouveau jour : effacer l'ancien vin
      await clearWineOfTheDay();
      return null;
    }

    final Map<String, dynamic> json = jsonDecode(wineString);
    return Wine.fromJson(json);
  }

  // Ajouter au history
  Future<void> addWineToHistory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    if (!history.contains(id.toString())) {
      history.add(id.toString());
      await prefs.setStringList(_historyKey, history);
    }
  }

  Future<void> clearWineOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wineKey);
    await prefs.remove(_dateKey);
  }

  Future<List<int>> getWineHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) => int.parse(e)).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
