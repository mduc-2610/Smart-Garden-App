import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';

class TTabBarTheme {
  static TabBarTheme tabBarTheme = const TabBarTheme(
    indicatorColor: TColor.primary,
    labelStyle: TextStyle(color: TColor.primary),
    indicatorSize: TabBarIndicatorSize.tab,
    // tabAlignment: TabAlignment.start,
  );
}
