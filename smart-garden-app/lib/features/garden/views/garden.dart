import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:smart_garden_app/features/garden/controllers/garden_controller.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_card.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:get/get.dart';

class MyGardenView extends StatelessWidget {
  final controller = Get.put(GardenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Gardens',
          style: Get.theme.textTheme.headlineLarge,
        ),
        actions: [
          Icon(Icons.add),
        ],
      ),
      body: MainWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: TSize.spaceBetweenSections),
            Obx(() {
              if (controller.isLoading.value) {
                return MyGardenSkeleton(); // Show skeleton while loading
              } else {
                return controller.show.value == ItemLayout.grid
                    ? buildGrid(context)
                    : buildList(context);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(BuildContext context) {
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

  Widget buildList(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: TDeviceUtil.getScreenHeight() * 0.35,
            child: Obx(() {
              if (controller.plants.isEmpty) {
                return Center(child: Text('No plants available'));
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
              effect: ExpandingDotsEffect(
                dotWidth: 8.0,
                dotHeight: 8.0,
                expansionFactor: 2,
                spacing: 12.0,
                dotColor: Colors.grey,
                activeDotColor: TColor.primary,
              ),
            ),
          ),
          SizedBox(height: TSize.spaceBetweenSections),
          Obx(() {
            if (controller.plants.isEmpty || controller.currentPage.value.toInt() >= controller.plants.length) {
              return SizedBox.shrink();
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Skeleton for PageView (replace with BoxSkeleton)
          SizedBox(
            height: TDeviceUtil.getScreenHeight() * 0.35,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return BoxSkeleton(
                  height: 180,
                  width: double.infinity,
                );
              },
            ),
          ),

          SizedBox(
            height: 20,
            child: BoxSkeleton(
              height: 8.0,
              width: double.infinity,
            ),
          ),
          SizedBox(height: TSize.spaceBetweenSections),

          PlantCareTrackerSkeleton(),
        ],
      ),
    );
  }
}
