import 'package:grape/models/rating.dart';

class Wine {
  final String winery;
  final String name;
  final Rating rating;
  final String location;
  final String image;
  final int id;

  Wine({
    required this.winery,
    required this.name,
    required this.rating,
    required this.location,
    required this.image,
    required this.id,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      winery: json['winery'] as String,
      name: json['wine'] as String,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      location: json['location'] as String,
      image: json['image'] as String,
      id: json['id'] as int,
    );
  }
}
