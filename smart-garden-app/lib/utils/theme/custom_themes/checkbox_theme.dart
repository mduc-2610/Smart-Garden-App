import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TCheckboxTheme {
  TCheckboxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if(states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      else  {
        return Colors.black;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith((states) {
      if(states.contains(MaterialState.selected)) {
        return TColor.primary;
      }
      else {
        return Colors.transparent;
      }
    })
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if(states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        else  {
          return Colors.black;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if(states.contains(MaterialState.selected)) {
          return TColor.primary;
        }
        else {
          return Colors.transparent;
        }
      })
  );

}