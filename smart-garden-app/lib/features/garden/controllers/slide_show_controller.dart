import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';

class SlideshowController extends GetxController {
  final plants = <Plant>[].obs;
  final currentIndex = 0.obs;
  final pageController = PageController();

  void updatePlants(List<Plant> plantList) {
    plants.value = plantList;
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
