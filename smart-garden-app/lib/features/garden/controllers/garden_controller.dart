import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/utils/constants/enums.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

class GardenController extends GetxController {
  static GardenController get instance => Get.find();

  var show = ItemLayout.list.obs;
  var currentPage = 0.0.obs;
  var pageController = PageController();

  void updatePageIndex(int index) {
    currentPage.value = index.toDouble();
  }

  void nextPage(int totalPages) {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
      pageController.animateToPage(
          currentPage.value.toInt(),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    } else {
      Get.offAllNamed('/home');
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
          currentPage.value.toInt(),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    }
  }

  void changeLayout() {
    switch (show.value) {
      case ItemLayout.grid:
        show.value = ItemLayout.list;
      default:
        show.value = ItemLayout.grid;
    }
  }

}