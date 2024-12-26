import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

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

        const SizedBox(height: TSize.spaceBetweenItemsVertical),

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

        const SizedBox(height: TSize.spaceBetweenItemsVertical),

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

class TrackingWidgetSkeleton extends StatelessWidget {
  const TrackingWidgetSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BoxSkeleton(
          height: 20,
          width: 70,
          borderRadius: TSize.borderRadiusSm,
        ),
        SizedBox(height: TSize.spaceBetweenItemsVertical),
        Stack(
          alignment: Alignment.center,
          children: [
            BoxSkeleton(
              height: 70,
              width: 70,
              borderRadius: TSize.borderRadiusCircle,
            ),
            BoxSkeleton(
              height: 30,
              width: 30,
              borderRadius: TSize.borderRadiusCircle,
            ),
          ],
        ),
        SizedBox(height: TSize.spaceBetweenItemsVertical),
        BoxSkeleton(
          height: 15,
          width: 50,
          borderRadius: TSize.borderRadiusSm,
        ),
        SizedBox(height: TSize.spaceBetweenItemsSm),
        BoxSkeleton(
          height: 15,
          width: 100,
          borderRadius: TSize.borderRadiusSm,
        ),
      ],
    );
  }
}
