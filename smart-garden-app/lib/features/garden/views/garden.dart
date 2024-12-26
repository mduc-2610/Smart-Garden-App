import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_garden_app/common/widgets/buttons/main_button.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:smart_garden_app/features/garden/controllers/garden_controller.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_card.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:get/get.dart';

class MyGardenView extends StatelessWidget {

  const MyGardenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GardenController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Garden',
          style: Get.theme.textTheme.headlineLarge,
        ),
        actions: const [
          // Icon(Icons.add),
        ],
      ),
      body: MainWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MainButton(
            //   onPressed: () async {
            //     final prefs = await SharedPreferences.getInstance();
            //     $print("Test ip ${prefs.getString(Constant.ESP32_IP_KEY)}");
            //   },
            //   text: "Test ip",
            // ),
            const SizedBox(height: TSize.spaceBetweenSections),
            Obx(() {
              if (controller.isLoading.value) {
                return const MyGardenSkeleton();
              } else {
                return controller.show.value == ItemLayout.grid
                    ? buildGrid(context, controller)
                    : buildList(context, controller);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(BuildContext context, GardenController controller) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.plants.length,
        itemBuilder: (context, index) {
          final plant = controller.plants[index];
          return PlantCard(plant: plant);
        },
      ),
    );
  }

  Widget buildList(BuildContext context, GardenController controller) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: TDeviceUtil.getScreenHeight() * 0.35,
            child: Obx(() {
              if (controller.plants.isEmpty) {
                return const Center(child: Text('No plants available'));
              }
              return PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.updatePageIndex,
                itemCount: controller.plants.length,
                itemBuilder: (context, index) {
                  final plant = controller.plants[index];
                  return PlantCard(
                    plant: plant,
                    background: Colors.transparent,
                  );
                },
              );
            }),
          ),
          SizedBox(
            height: 20,
            child: SmoothPageIndicator(
              controller: controller.pageController,
              count: controller.plants.length,
              effect: const ExpandingDotsEffect(
                dotWidth: 8.0,
                dotHeight: 8.0,
                expansionFactor: 2,
                spacing: 12.0,
                dotColor: Colors.grey,
                activeDotColor: TColor.primary,
              ),
            ),
          ),
          const SizedBox(height: TSize.spaceBetweenSections),
          Obx(() {
            if (controller.plants.isEmpty || controller.currentPage.value.toInt() >= controller.plants.length) {
              return const SizedBox.shrink();
            }
            final plant = controller.plants[controller.currentPage.value.toInt()];
            return PlantCareTracker(plant: plant);
          }),
        ],
      ),
    );
  }
}
class MyGardenSkeleton extends StatelessWidget {
  const MyGardenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          BoxSkeleton(
            height: TDeviceUtil.getScreenHeight() * 0.35,
            width: double.infinity,
          ),
          const SizedBox(height: TSize.spaceBetweenSections),

          const PlantCareTrackerSkeleton(),
        ],
      ),
    );
  }
}
