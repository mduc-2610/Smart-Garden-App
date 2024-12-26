import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/garden_menu_redirection.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.0.obs;
  var pageController = PageController();

  void nextPage(int totalPages) {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
      pageController.animateToPage(
          currentPage.value.toInt(),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    } else {
      Get.offAll(() => GardenMenuRedirection());
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
          currentPage.value.toInt(),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    }
  }
}
