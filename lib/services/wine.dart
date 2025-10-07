import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/wine_model.dart';

Future<List<Wine>> fetchRedWines() async {
  final response = await http.get(
    Uri.parse('https://api.sampleapis.com/wines/reds'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> winesJson = jsonDecode(response.body) as List<dynamic>;
    return winesJson.map((json) => Wine.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load wines');
  }
}

