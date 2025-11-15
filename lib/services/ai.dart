import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grape/models/wine_details.dart';

final Map<String, WineDetails> _wineDetailsCache = {};

Future<WineDetails> getWineDetails(String wineName) async {
  if (_wineDetailsCache.containsKey(wineName)) {
    return _wineDetailsCache[wineName]!;
  }
  
  await dotenv.load(fileName: ".env");
  bool useAi = dotenv.env['USE_AI'] == 'true';
  if (!useAi) {
    return WineDetails(
      description: "description",
      grapeVariety: "grapeVariety",
      foodPairings: "foodPairings",
      alcoolPercentage: "12%",
      agingPotential: "agingPotential",
      servingTemperature: "servingTemperature",
    );
  }

  String apiKey = dotenv.env['GEMINI_AI_TOKEN'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('GEMINI_AI_TOKEN not set. Run with --dart-define=GEMINI_AI_TOKEN=your_key');
  }
  const model = 'gemini-2.5-flash';
  final prompt = 'Based on the wine name "$wineName", provide a json with the following details in French:, '
      '1. A brief description of the wine, '
      '2. The grape variety used, '
      '3. The recommended food pairings, '
      '4. The alcohol percentage, '
      '5. The aging potential '
      '6. The serving temperature '
      'Format the response as a JSON object with keys: description, grape_variety, food_pairings, alcool_percentage, aging_potential, serving_temperature.';

  final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$apiKey');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
    }),
  );

  if (response.statusCode == 200) {
    final raw = jsonDecode(response.body);
    String? contentText;
    if (raw is Map && raw['candidates'] is List && (raw['candidates'] as List).isNotEmpty) {
      final candidate = (raw['candidates'] as List).first;
      final content = candidate is Map ? candidate['content'] : null;
      if (content is Map && content['parts'] is List && (content['parts'] as List).isNotEmpty) {
      final part = (content['parts'] as List).first;
      contentText = part is Map ? part['text'] as String? : part as String?;
      }
    }

    String jsonString = contentText ?? response.body;

    // Remove surrounding triple-backtick code fences (optionally with "json")
    final codeBlock = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```', multiLine: true);
    final match = codeBlock.firstMatch(jsonString);
    if (match != null) {
      jsonString = match.group(1)!;
    }

    jsonString = jsonString.trim();
    final data = jsonDecode(jsonString);

    _wineDetailsCache[wineName] = WineDetails.fromJson(data);
    return WineDetails.fromJson(data);
  } else {
    throw Exception('Erreur: ${response.statusCode}');
  }
}
