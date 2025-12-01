import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/services/wine.dart';
import '../models/wine.dart';
import 'wine_storage_service.dart';

class WineOfTheDayService {
  final WineStorageService _storage = WineStorageService();
  final Ref ref;
  WineOfTheDayService(this.ref);


  Future<Wine> getWineOfTheDay() async {
    // Vérifier si un vin du jour existe déjà pour aujourd'hui
    final savedWine = await _storage.getWineOfTheDay();
    if (savedWine != null) return savedWine;

    // Charger tous les vins
    final winesAsync = ref.watch(wineListProvider);
    final wines = winesAsync.when(
      data: (list) => list,
      loading: () => [], // tu peux aussi attendre ou throw si tu veux
      error: (e, _) => throw e,
    );
    //final Future<List<Wine>> wines;
    //wines = fetchRedWines();

    final history = await _storage.getWineHistory();

    // Filtrer les vins déjà tirés
    final availableWines = wines.where((w) => !history.contains(w.id)).toList();

    Wine selectedWine;
    if (availableWines.isEmpty) {
      // Si tous les vins ont été tirés, reset history
      await _storage.clearHistory();
      selectedWine = (await wines)[Random().nextInt((await wines).length)];
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
