import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TSwitchTheme {
  TSwitchTheme._();

  static final switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.all(
      TColor.light
    ),
    trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return TColor.primary;
      }
      return TColor.textDesc;
    }),
    trackOutlineColor: WidgetStateProperty.all(
      Colors.transparent
    )
  );
}
