class WineDetails {
  final String description;
  final String grapeVariety;
  final String foodPairings;
  final String servingTemperature;
  final String agingPotential;

  WineDetails({
    required this.description,
    required this.grapeVariety,
    required this.foodPairings,
    required this.servingTemperature,
    required this.agingPotential,
  });

  factory WineDetails.fromJson(Map<String, dynamic> json) {
    String toString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is List) return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).join(', ');
      return value.toString();
    }

    return WineDetails(
      description: toString(json['description']),
      grapeVariety: toString(json['grape_variety']),
      foodPairings: toString(json['food_pairings']),
      servingTemperature: toString(json['serving_temperature']),
      agingPotential: toString(json['aging_potential']),
    );
  }
}