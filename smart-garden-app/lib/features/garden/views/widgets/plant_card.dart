import 'package:flutter/material.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/features/garden/views/plant_detail.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/image_strings.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final double? width;
  final Color? background;
  final VoidCallback? onPressed;

  const PlantCard({super.key, 
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
      return const Color(0xff577943);
    }

    return InkWell(
      onTap: onPressed ?? () {
        Get.to(() => const PlantDetail(), arguments: {
          "id": plant.id
        });
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
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${plant.name}",
                        style: Get.theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xff577943),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        '5 days',
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          color: determineTextColor().withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSize.spaceBetweenItemsVertical),
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(TSize.borderRadiusLg),
                      child: Image.network(
                        plant?.imageUrl ?? TImage.plant1,
                        fit: BoxFit.contain,
                      ),
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