import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/wine.dart';
import '../models/rating.dart';
import 'dart:developer';

final defaultWine = Wine(
  id: -1,
  winery: 'Domaine Inconnu',
  name: 'Vin de Secours',
  rating: Rating(average: 'N/A', reviews: '0'),
  location: 'Indisponible',
  image: 'https://placehold.co/600x400.png',
);

Future<List<Wine>> fetchRedWines() async {
  try {
    log('data: fetching started');
    final response = await http.get(
      Uri.parse('https://api.sampleapis.com/wines/reds'),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('La requête a dépassé le délai imparti');
      },
    );
    log('data: fetching completed with status code ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> winesJson = jsonDecode(response.body) as List<dynamic>;
      final wines = winesJson.map((json) => Wine.fromJson(json as Map<String, dynamic>));

      final filteredWines = wines
        .where((wine) => (wine.image).toLowerCase().endsWith('.png'))
        .toList();
      
      // S'il n'y a aucun vin valide, retourner le vin par défaut
      return filteredWines.isNotEmpty ? filteredWines : [defaultWine];
    } else {
      log('data: error - status code ${response.statusCode}');
      return [defaultWine];
    }
  } catch (e) {
    log('data: error - $e');
    return [defaultWine];
  }
}

List<Wine> filterWines(List<Wine> wines, String? country, String? cityAndRegion) {
  if (cityAndRegion != null && cityAndRegion.isNotEmpty) {
    final byCityOrRegion = wines.where((wine) => wine.location.contains(cityAndRegion)).toList();
    if (byCityOrRegion.isNotEmpty) return byCityOrRegion;
  }
  if (country != null && country.isNotEmpty) {
    final byCountry = wines.where((wine) => wine.location.contains(country)).toList();
    if (byCountry.isNotEmpty) return byCountry;
  }
  return wines;
}

