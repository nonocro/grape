class Wine {
  final String winery;
  final String wine;
  final Rating rating;
  final String location;
  final String image;
  final int id;

  Wine({
    required this.winery,
    required this.wine,
    required this.rating,
    required this.location,
    required this.image,
    required this.id,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      winery: json['winery'] as String,
      wine: json['wine'] as String,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      location: json['location'] as String,
      image: json['image'] as String,
      id: json['id'] as int,
    );
  }
}

class Rating {
  final String average;
  final String reviews;

  Rating({
    required this.average,
    required this.reviews,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average'] as String,
      reviews: json['reviews'] as String,
    );
  }
}