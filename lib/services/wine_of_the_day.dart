import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:grape/services/wine_storage_service.dart';
import '../models/wine.dart';
import 'dart:math';


class WineOfTheDayService {
  final storage = WineStorageService();


  Future<Wine> pickWineOfTheDay() async {
    final String response = await rootBundle.loadString('assets/data/wines.json');
    final List<dynamic> jsonList = jsonDecode(response);

    final wines = jsonList.map((json) => Wine.fromJson(json)).toList();
    final wineId = Random().nextInt(wines.length);
    await storage.saveWineOfTheDay(wineId);
    return wines.firstWhere((wine) => wine.id == wineId);
  }

  Future<Wine> getSavedWineOfTheDay() async {
    Wine wineOfTheDay;
    final wineId = await storage.getWineOfTheDayId();
    if (wineId == null) {
      wineOfTheDay = await pickWineOfTheDay();
    } else {
      final String response = await rootBundle.loadString('assets/data/wines.json');
      final List<dynamic> jsonList = jsonDecode(response);
      final wines = jsonList.map((json) => Wine.fromJson(json)).toList();

      wineOfTheDay = wines.firstWhere((wine) => wine.id == wineId);
    }
    return wineOfTheDay;
  }


}