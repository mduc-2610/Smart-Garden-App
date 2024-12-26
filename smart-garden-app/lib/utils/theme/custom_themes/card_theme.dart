import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

class TCardTheme {
  TCardTheme._();

  static CardTheme lightCardTheme = const CardTheme(
    color: TColor.light,
    shadowColor: TColor.dark,
    surfaceTintColor: TColor.light,
    elevation: TSize.cardElevation,
  );

  static CardTheme darkCardTheme = CardTheme(
    color: TColor.dark,
    shadowColor: TColor.light.withOpacity(0.3),
    surfaceTintColor: TColor.dark,
    elevation: TSize.cardElevation
  );
}