import 'package:flutter/cupertino.dart';
import 'package:smart_garden_app/data/services/api_service.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/utils/constants/times.dart'; // Replace with actual API constants file

class GardenController extends GetxController {
  static GardenController get instance => Get.find();

  var show = ItemLayout.list.obs;
  var currentPage = 0.0.obs;
  var pageController = PageController();

  var plants = <Plant>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    try {
      isLoading.value = true;
      final response = await APIService<Plant>(
        fullUrl: '${APIConstant.baseCSUrl}/plant',
        allNoBearer: true,
      ).list();
      plants.value = response;
      await Future.delayed(const Duration(milliseconds: TTime.init));
    } catch (error) {
      print("Error fetching plants: $error");
    } finally {
      isLoading.value = false;
    }
    update();
    // isLoading.value = false;
  }

  void updatePageIndex(int index) {
    currentPage.value = index.toDouble();
  }

  void nextPage(int totalPages) {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value.toInt(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void changeLayout() {
    switch (show.value) {
      case ItemLayout.grid:
        show.value = ItemLayout.list;
        break;
      default:
        show.value = ItemLayout.grid;
        break;
    }
  }
}
