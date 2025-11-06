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