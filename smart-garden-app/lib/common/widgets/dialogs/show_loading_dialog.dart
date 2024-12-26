import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

void openLoadingDialog(String text, String animation) {
  showDialog(
    context: Get.overlayContext!,
    barrierDismissible:  false,
    builder: (_) => PopScope(
      canPop: false,
      child: Container(
        color: THelperFunction.isDarkMode(Get.context!) ? TColor.dark : TColor.light,
        width: double.infinity,
        height: double.infinity,
        child: const Column(
          children: [
            SizedBox(height: 250,),

          ]
        ),
      ),
    )
  );
}