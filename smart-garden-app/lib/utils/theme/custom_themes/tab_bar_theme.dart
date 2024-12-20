import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:get/get.dart';

class TTabBarTheme {
  static TabBarTheme tabBarTheme = TabBarTheme(
    indicatorColor: TColor.primary,
    labelStyle: TextStyle(color: TColor.primary),
    indicatorSize: TabBarIndicatorSize.tab,
    // tabAlignment: TabAlignment.start,
  );
}
