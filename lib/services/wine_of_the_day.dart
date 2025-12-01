import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:grape/services/wine.dart';
import '../models/wine.dart';
import 'wine_storage_service.dart';

class WineOfTheDayService {
  final WineStorageService _storage = WineStorageService();

  Future<Wine> getWineOfTheDay() async {
    // Vérifier si un vin du jour existe déjà pour aujourd'hui
    final savedWine = await _storage.getWineOfTheDay();
    if (savedWine != null) return savedWine;

    // Charger tous les vins
    final Future<List<Wine>> _wines;
    _wines = fetchRedWines();

    final history = await _storage.getWineHistory();

    // Filtrer les vins déjà tirés
    final availableWines = (await _wines).where((w) => !history.contains(w.id)).toList();

    Wine selectedWine;
    if (availableWines.isEmpty) {
      // Si tous les vins ont été tirés, reset history
      await _storage.clearHistory();
      selectedWine = (await _wines)[Random().nextInt((await _wines).length)];
    } else {
      selectedWine = availableWines[Random().nextInt(availableWines.length)];
    }

    // Sauvegarder le vin du jour
    await _storage.saveWineOfTheDay(selectedWine);
    return selectedWine;
  }


  Future<bool> isWineAlreadyDiscovered() async {
    final wine = await _storage.getWineOfTheDay();
    return wine != null;
  }

  Future<void> reset() async {
    await _storage.clearWineOfTheDay();
  }
}
