import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return TColor.buttonDisabled;
        }
        return TColor.primary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: TColor.buttonDisabled);
        }
        return const BorderSide(color: TColor.primary);
      }),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return TColor.buttonDisabled;
        }
        return TColor.primary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: TColor.buttonDisabled);
        }
        return const BorderSide(color: TColor.primary);
      }),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ),
  );
}
