import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app/features/garden/models/garden/plant.dart';

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
