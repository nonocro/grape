import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wine.dart';

class WineStorageService {
  static const String _wineKey = 'wine_of_the_day';
  static const String _dateKey = 'wine_date';
  static const String _historyKey = 'wine_history';


  Future<void> saveWineOfTheDay(Wine wine) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String();

    final wineJson = jsonEncode({
      'id': wine.id,
      'winery': wine.winery,
      'wine': wine.wine,
      'location': wine.location,
      'image': wine.image,
      'rating': {
        'average': wine.rating.average,
        'reviews': wine.rating.reviews,
      },
    });

    await prefs.setString(_wineKey, wineJson);
    await prefs.setString(_dateKey, today);
    await addWineToHistory(wine.id);
  }

  Future<Wine?> getWineOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final wineString = prefs.getString(_wineKey);
    final savedDate = prefs.getString(_dateKey);

    if (wineString == null || savedDate == null) return null;

    final saved = DateTime.parse(savedDate);
    final now = DateTime.now();
    final test = DateTime(2025, 11, 4);
    // On vérifie si la date a changé par rapport à notre dernier enregistrement
    final isAnotherDay =
        test.year != now.year || test.month != now.month || test.day != now.day;

    if (isAnotherDay) {
      // Si un autre jour, on efface le vin
      await clearWineOfTheDay();
      return null;
    }

    final Map<String, dynamic> json = jsonDecode(wineString);
    return Wine.fromJson(json);
  }

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
