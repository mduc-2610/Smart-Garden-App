import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constants/colors.dart';
import 'package:food_delivery_app/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/features/garden/models/garden/plant.dart';
import 'package:food_delivery_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';

class PlantDetail extends StatelessWidget {
  final Plant plant;

  const PlantDetail({
    required this.plant
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? TColor.light : TColor.dark,),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete, ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${plant.name}",
              style: Get.textTheme.displayMedium,
            ),
            SizedBox(height: 8),
            Text(
              "Robust and dramatic, with no leaves.",
              style: Get.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: TSize.spaceBetweenSections * 2,),

            Center(
              child: Image.asset(
                TImage.plant1,
                height: 150,
              ),
            ),
            SizedBox(height: TSize.spaceBetweenItemsVertical,),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(icon: Icons.wb_sunny_outlined, text: "Sun 8 - 12 hrs"),
                          SizedBox(height: TSize.spaceBetweenItemsSm,),

                          InfoRow(icon: Icons.water_drop_outlined, text: "Every 7 days"),
                          SizedBox(height: TSize.spaceBetweenItemsSm,),

                          InfoRow(icon: Icons.thermostat_outlined, text: "Best at 18°C - 30°C"),
                          SizedBox(height: TSize.spaceBetweenItemsSm,),

                          InfoRow(icon: Icons.spa_outlined, text: "Sprouts in: 7 - 14 days"),
                          SizedBox(height: TSize.spaceBetweenItemsSm,),

                          InfoRow(icon: Icons.favorite_border, text: "Enjoy for: 90 - 112 days"),
                          SizedBox(height: TSize.spaceBetweenItemsSm,),
                        ],
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     alignment: Alignment.center,
                //     child: Image.asset(
                //       TImage.plant1,
                //       height: 150,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: TSize.spaceBetweenSections * 2,),

            PlantCareTracker(plant: plant, direction: Axis.horizontal,),

          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        SizedBox(width: TSize.spaceBetweenItemsHorizontal),
        Text(
          text,
          style: Get.theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
