import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/buttons/small_button.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/garden/controllers/plant_detail_controller.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/features/garden/views/plant_detail_moisture.dart';
import 'package:smart_garden_app/features/garden/views/widgets/info_card.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';

class PlantDetail extends StatelessWidget {
  final Plant plant;

  const PlantDetail({
    required this.plant
  });

  @override
  Widget build(BuildContext context) {
    final PlantDetailController controller = Get.put(PlantDetailController(plant: plant));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? TColor.light : TColor.dark,),
          onPressed: () {
            Get.back();
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit, ),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.delete, ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SizedBox(
        height: TDeviceUtil.getScreenHeight(),
        child: SingleChildScrollView(
          child: MainWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${plant.name}",
                  style: Get.textTheme.displayMedium,
                ),
                SizedBox(height: TSize.spaceBetweenItemsVertical),
                Text(
                  "Robust and dramatic, with no leaves.",
                  style: Get.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: TSize.spaceBetweenItemsVertical,),

                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: SmallButton(
                        onPressed: () {
                          Get.to(() => PlantDetailMoistureView(plant: plant));
                        },
                        text: "View moisture history",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TSize.spaceBetweenItemsVertical,),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        // color: Colors.white,
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
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(TSize.borderRadiusLg),
                          child: Image.asset(
                            TImage.plant1,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TSize.spaceBetweenItemsVertical,),

                Obx(() => Row(
                  children: [
                    InfoCard(
                      title: "Valve state",
                      value: controller.isOpen.value ? "On" : "Off",
                      icon: Icons.water_drop_outlined,
                      color: controller.isOpen.value ? Colors.cyan : Colors.grey,
                      showSwitch: true,
                      switchValue: controller.isOpen.value,
                      onSwitchChanged: controller.toggleOpen,
                      disabled: controller.isValveAuto.value,
                    ),
                    SizedBox(width: TSize.spaceBetweenItemsHorizontal,),

                    InfoCard(
                      title: "Valve auto",
                      value: controller.isValveAuto.value ? "On" : "Off",
                      icon: Icons.auto_awesome,
                      color: Colors.orange,
                      showSwitch: true,
                      switchValue: controller.isValveAuto.value,
                      onSwitchChanged: controller.toggleValveAuto,
                    ),
                  ],
                ),),
                SizedBox(height: TSize.spaceBetweenItemsVertical,),

                PlantCareTracker(plant: plant, direction: Axis.horizontal,),

              ],
            ),
          ),
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
