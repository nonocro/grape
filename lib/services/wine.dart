import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/wine.dart';
import 'dart:developer';

Future<List<Wine>> fetchRedWines() async {
  log('data: fetching started');
  final response = await http.get(
    Uri.parse('https://api.sampleapis.com/wines/reds'),
  );
  log('data: fetching completed with status code ${response.statusCode}');

  if (response.statusCode == 200) {
    final List<dynamic> winesJson = jsonDecode(response.body) as List<dynamic>;
    final wines = winesJson.map((json) => Wine.fromJson(json as Map<String, dynamic>));

    return wines
      .where((wine) => (wine.image).toLowerCase().endsWith('.png'))
      .toList();
  } else {
    throw Exception('Failed to load wines');
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

