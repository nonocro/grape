import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/wine.dart';
import 'wine_storage_service.dart';

class WineOfTheDayService {
  final WineStorageService _storage = WineStorageService();

  Future<Wine> getWineOfTheDay() async {
    final String response = await rootBundle.loadString('assets/data/data.json');
    final List<dynamic> jsonList = jsonDecode(response);
    final wines = jsonList.map((json) => Wine.fromJson(json)).toList();

    final history = await _storage.getWineHistory();

    // Filtrer les vins déjà tirés
    final availableWines = wines.where((w) => !history.contains(w.id)).toList();

    if (availableWines.isEmpty) {
      await _storage.clearHistory();
      return getWineOfTheDay();
    }

    final randomWine = availableWines[Random().nextInt(availableWines.length)];

    await _storage.saveWineOfTheDay(randomWine);

    return randomWine;
  }
}
