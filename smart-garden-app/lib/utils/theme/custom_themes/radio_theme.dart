import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TRadioTheme {
  TRadioTheme._();

  static RadioThemeData radioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.all(
        TColor.primary
    ),
    visualDensity: const VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}