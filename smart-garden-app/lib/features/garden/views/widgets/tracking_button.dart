import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';

class TrackingWidget extends StatelessWidget {
  final String topText;
  final IconData iconData;
  final Color progressColor;
  final double progressValue;
  final String middleText;
  final String bottomText;
  final VoidCallback? onPressed;

  const TrackingWidget({
    Key? key,
    required this.topText,
    required this.iconData,
    required this.progressColor,
    required this.progressValue,
    required this.middleText,
    required this.bottomText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          topText,
          style: Get.theme.textTheme.headlineSmall,
        ),

        SizedBox(height: TSize.spaceBetweenItemsVertical),

        InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: TSize.strokeWidthSm,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),

              Icon(
                iconData,
                color: progressColor,
                size: TSize.iconMd,
              ),
            ],
          ),
        ),

        SizedBox(height: TSize.spaceBetweenItemsVertical),

        Text(
          middleText,
          style: Get.theme.textTheme.headlineSmall,
        ),

        Text(
          bottomText,
          style: Get.theme.textTheme.bodySmall?.copyWith(
            fontSize: TSize.fontSizeMd
          ),
        ),
      ],
    );
  }
}