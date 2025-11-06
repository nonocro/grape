import 'package:grape/models/rating.dart';

class Wine {
  final String winery;
  final String name;
  final Rating rating;
  final String location;
  final String image;
  final int id;
  final double latitude;
  final double longitude;

  Wine({
    required this.winery,
    required this.name,
    required this.rating,
    required this.location,
    required this.image,
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    double parseCoordinate(dynamic value) {
      if (value == null) return 0.0; // valeur par défaut si absente
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Wine(
      winery: json['winery'] as String? ?? 'Inconnu',
      name: json['wine'] as String? ?? 'Inconnu',
      rating: json['rating'] != null
          ? Rating.fromJson(json['rating'] as Map<String, dynamic>)
          : Rating(average: '0', reviews: '0'),
      location: json['location'] as String? ?? 'Inconnu',
      image: json['image'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
    );
  }
}
