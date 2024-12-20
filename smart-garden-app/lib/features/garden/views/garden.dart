import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/garden/controllers/garden_controller.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_care_tracker.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';

import 'package:smart_garden_app/utils/constants/image_strings.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/views/widgets/plant_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyGardenView extends StatefulWidget {
  @override
  _MyGardenViewState createState() => _MyGardenViewState();
}

class _MyGardenViewState extends State<MyGardenView> {
  final plants = [
    Plant(
      name: 'Ailanthus',
      imageUrl: TImage.plant1,
      waterDaysPerWeek: 10,
      plantDays: 10,
      lightPercentPerDay: 65,
    ),
    Plant(
      name: 'Excelsa',
      imageUrl: TImage.plant1,
      waterDaysPerWeek: 7,
      plantDays: 7,
      lightPercentPerDay: 75,
    ),
  ];
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
            SizedBox(height: TSize.spaceBetweenSections,),

            // Obx(() => Row(
            //   children: [
            //     InkWell(
            //       onTap: controller.changeLayout,
            //       child: Icon(
            //         Icons.crop_square_rounded,
            //         color: (controller.show == ItemLayout.grid)
            //             ? Colors.grey.withOpacity(0.5)
            //             : Colors.black,
            //         size: TSize.iconLg,
            //       ),
            //     ),
            //     InkWell(
            //       onTap: controller.changeLayout,
            //       child: Icon(
            //         Icons.grid_view,
            //         color: (controller.show == ItemLayout.list)
            //             ? Colors.grey.withOpacity(0.5)
            //             : Colors.black,
            //         size: TSize.iconLg,
            //       ),
            //     ),
            //   ],
            // ),),
            SizedBox(height: TSize.spaceBetweenSections,),

            Obx(() =>
              (controller.show == ItemLayout.grid)
                ? buildGrid(context)
                : buildList(context)
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
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
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndex,
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return PlantCard(
                  plant: plant,
                  background: Colors.transparent,
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
            child: SmoothPageIndicator(
              controller: controller.pageController, // Same controller
              count: plants.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8.0,
                dotHeight: 8.0,
                expansionFactor: 2,
                spacing: 12.0,
                dotColor: Colors.grey,
                activeDotColor: TColor.primary
              ),
            ),
          ),


          SizedBox(height: TSize.spaceBetweenSections,),

          Obx(() {
            final plant = plants[controller.currentPage.value.toInt()];
            return PlantCareTracker(plant: plant);
          }),
        ],
      ),
    );
  }
}
