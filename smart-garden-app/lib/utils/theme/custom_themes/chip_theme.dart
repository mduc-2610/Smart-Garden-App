import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.green),
    selectedColor: TColor.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    checkmarkColor: Colors.white
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
      disabledColor: Colors.grey,
      labelStyle: TextStyle(color: Colors.white),
      selectedColor: TColor.primary,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      checkmarkColor: Colors.white
  );
}