import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/buttons/small_button.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:smart_garden_app/features/garden/controllers/plant_detail_controller.dart';
import 'package:smart_garden_app/features/garden/views/plant_detail_moisture.dart';
import 'package:smart_garden_app/features/garden/views/widgets/info_card.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';


class PlantDetail extends StatelessWidget {
  const PlantDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlantDetailController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? TColor.light : TColor.dark),
          onPressed: () {
            $print('okokokokok');
            Get.back();
          },
        ),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const PlantDetailSkeleton();
          }

          final plant = controller.plant.value!;
          return SizedBox(
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
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),
                    Text(
                      "Robust and dramatic, with no leaves.",
                      style: Get.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),
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
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 16,
                                bottom: 16,
                                left: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoRow(icon: Icons.wb_sunny_outlined, text: "Sun 8 - 12 hrs"),
                                  SizedBox(height: TSize.spaceBetweenItemsSm),
                                  InfoRow(icon: Icons.water_drop_outlined, text: "Every 7 days"),
                                  SizedBox(height: TSize.spaceBetweenItemsSm),
                                  InfoRow(icon: Icons.thermostat_outlined, text: "Best at 18°C - 30°C"),
                                  SizedBox(height: TSize.spaceBetweenItemsSm),
                                  InfoRow(icon: Icons.spa_outlined, text: "Sprouts in: 7 - 14 days"),
                                  SizedBox(height: TSize.spaceBetweenItemsSm),
                                  InfoRow(icon: Icons.favorite_border, text: "Enjoy for: 90 - 112 days"),
                                  SizedBox(height: TSize.spaceBetweenItemsSm),
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
                              child: Image.network(
                                plant?.imageUrl ?? TImage.plant1,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),
                    Row(
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
                        const SizedBox(width: TSize.spaceBetweenItemsHorizontal,),

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
                    ),
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),
                    PlantCareTracker(plant: plant,),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: TSize.spaceBetweenItemsHorizontal),
        Text(
          text,
          style: Get.theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}

class PlantDetailSkeleton extends StatelessWidget {
  const PlantDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TDeviceUtil.getScreenHeight(),
      child: SingleChildScrollView(
        child: MainWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BoxSkeleton(
                height: 50,
                width: 200,
                borderRadius: TSize.borderRadiusLg,
              ),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),

              const BoxSkeleton(
                height: 15,
                width: 150,
                borderRadius: TSize.borderRadiusSm,
              ),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),

              const Row(
                children: [
                  BoxSkeleton(
                    width: 200,
                    height: 40,
                    borderRadius: TSize.borderRadiusLg,
                  ),
                ],
              ),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),

              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoxSkeleton(height: 18, width: 200, borderRadius: TSize.borderRadiusSm),
                            SizedBox(height: TSize.spaceBetweenItemsSm),
                            BoxSkeleton(height: 18, width: 200, borderRadius: TSize.borderRadiusSm),
                            SizedBox(height: TSize.spaceBetweenItemsSm),
                            BoxSkeleton(height: 18, width: 200, borderRadius: TSize.borderRadiusSm),
                            SizedBox(height: TSize.spaceBetweenItemsSm),
                            BoxSkeleton(height: 18, width: 200, borderRadius: TSize.borderRadiusSm),
                            SizedBox(height: TSize.spaceBetweenItemsSm),
                            BoxSkeleton(height: 18, width: 200, borderRadius: TSize.borderRadiusSm),
                            SizedBox(height: TSize.spaceBetweenItemsSm),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSize.spaceBetweenItemsMd),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(TSize.borderRadiusLg),
                        child: const BoxSkeleton(
                          height: 150,
                          width: 150,
                          borderRadius: TSize.borderRadiusLg,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),

              const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InfoCardSkeleton(),
                  ),
                  SizedBox(width: TSize.spaceBetweenItemsHorizontal),
                  Expanded(
                    flex: 1,
                    child: InfoCardSkeleton(),
                  ),
                ],
              ),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),
              const SizedBox(height: TSize.spaceBetweenItemsVertical),

              // Plant Care Tracker Skeleton
              const PlantCareTrackerSkeleton(direction: Axis.horizontal),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCardSkeleton extends StatelessWidget {
  const InfoCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxSkeleton(height: 20, width: 50, borderRadius: TSize.borderRadiusSm),
            SizedBox(height: TSize.spaceBetweenItemsSm),
            BoxSkeleton(height: 15, width: 100, borderRadius: TSize.borderRadiusSm),
            SizedBox(height: TSize.spaceBetweenItemsSm),
            BoxSkeleton(height: 15, width: 100, borderRadius: TSize.borderRadiusSm),
          ],
        ),
      ),
    );
  }
}

