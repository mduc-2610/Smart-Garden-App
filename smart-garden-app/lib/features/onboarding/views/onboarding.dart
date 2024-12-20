import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/buttons/main_button.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/onboarding/controllers/onboarding_controller.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/image_strings.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pages = [
    {
      "image": TImage.onBoarding1,
      "title": "Hello!",
      "title2": "Let's get your new smart garden set up.",
      "description": "For the next steps, make sure you have your Wi-Fi name and password handy.",
      "buttonText": "Next",
    },
    {
      "image": TImage.onBoarding2,
      "title": "Unbox Me",
      "title2": "Check components",
      "description": "Your smart garden package contains your garden, a package of sensors, sensors holder, Germination Domes, and Power Adapter.",
      "buttonText": "Next",
    },
    {
      "image": TImage.onBoarding3,
      "title": "WiFi Pairing",
      "title2": "Connect to a Network",
      "description": "Next, we'll need to connect your device to the internet so we can update its firmware and activate its smart garden features.",
      "buttonText": "Next",
    },
  ];

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                controller.currentPage.value = index.toDouble();
              },
              itemBuilder: (context, index) {
                final page = pages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        page["title"],
                        style: Get.theme.textTheme.displayMedium
                      ),
                      Image.asset(
                        page["image"],
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: TSize.spaceBetweenItemsVertical),
                      Center(
                        child: Text(
                          page["title2"],
                          textAlign: TextAlign.center,
                          style: Get.theme.textTheme.headlineMedium,
                        ),
                      ),
                      SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        page["description"],
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.titleSmall,
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => MainWrapper(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: TDeviceUtil.getScreenWidth() * 0.85,
                child: LinearProgressIndicator(
                  value: (controller.currentPage.value + 1) / pages.length,
                  color: TColor.primary,
                  backgroundColor: Colors.teal.shade100,
                ),
              ),
              SizedBox(height: TSize.spaceBetweenItemsVertical,),

              MainButton(
                onPressed: () => controller.previousPage(),
                text: "Back",
                backgroundColor: Colors.transparent,
                textColor: TColor.primary,
                placeholder: !(controller.currentPage.value > 0),
              ),
              // if (controller.currentPage.value > 0)...[

                SizedBox(height: TSize.spaceBetweenItemsVertical,),
              // ],
              MainButton(
                onPressed: () => controller.nextPage(pages.length),
                text: pages[controller.currentPage.value.toInt()]["buttonText"],
              ),
              SizedBox(height: TSize.spaceBetweenSections,),
            ],
          ),
        ),
      )),
    );
  }
}
