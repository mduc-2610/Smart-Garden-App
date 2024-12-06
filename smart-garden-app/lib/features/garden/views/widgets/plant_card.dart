import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/garden/views/plant_detail.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/features/garden/models/garden/plant.dart';
import 'package:food_delivery_app/utils/constants/colors.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final double? width;
  final Color? background;
  final VoidCallback? onPressed;

  PlantCard({
    required this.plant,
    this.width,
    this.background = const Color(0xffaeceb0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color determineTextColor() {
      if (background == Colors.transparent) {
        return Get.isDarkMode
            ? TColor.light
            : TColor.dark;
      }
      return Color(0xff577943);
    }

    return InkWell(
      onTap: onPressed ?? () {
        Get.to(() => PlantDetail(plant: plant));
      },
      child: SizedBox(
        width: width,
        child: Card(
          color: background ?? Colors.white,
          shadowColor: background == Colors.transparent
              ? Colors.transparent
              : null,
          elevation: background == Colors.transparent ? 0 : null,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        plant.name,
                        style: Get.theme.textTheme.headlineMedium?.copyWith(
                          color: Color(0xff577943),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        '${plant.plantDays} days',
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          color: determineTextColor().withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: TSize.spaceBetweenItemsVertical),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(TSize.borderRadiusLg),
                    child: Image.asset(
                      plant.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}