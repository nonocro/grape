import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.backgroundColor,
    required this.cardColor,
    required this.accentColor
  });

  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;

  @override
  AppColorsExtension copyWith({
    Color? backgroundColor,
    Color? cardColor,
    Color? accentColor
  }) {
    return AppColorsExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
      accentColor: accentColor ?? this.accentColor
    );
  }

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    
    return AppColorsExtension(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!
    );
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    cardColor,
    accentColor,
  );

  @override
  bool operator ==(covariant AppColorsExtension other) {
    if (identical(this, other)) return true;
    return other.backgroundColor == backgroundColor &&
        other.cardColor == cardColor &&
        other.accentColor == accentColor;
  }
}

extension BuildContextAppColorsExtension on BuildContext {
  AppColorsExtension get appColors => Theme.of(this).extension<AppColorsExtension>()!;
}