import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/data/services/api_service.dart';
import 'package:smart_garden_app/features/garden/models/Moisture.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';

class PlantDetailMoistureController extends GetxController {
  final Plant plant;

  var isLoading = true.obs;
  var moistureData = <Moisture>[].obs;
  var filteredData = <Moisture>[].obs;
  var selectedDate = DateTime.now().obs;
  var startTime = 0.obs;
  var endTime = 24.obs;
  var selectedTimeFormat = 'HH:mm:ss'.obs;
  int pageSize = 1000;

  PlantDetailMoistureController({required this.plant});

  @override
  void onInit() {
    super.onInit();
    fetchMoistureData();
  }

  void setTimeFormat(String format) {
    selectedTimeFormat.value = format;
    fetchMoistureData();
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setStartTime(int time) {
    if (time >= 0 && time <= 24) {
      startTime.value = time;
    }
  }

  void setEndTime(int time) {
    if (time >= 0 && time <= 24) {
      endTime.value = time;
    }
  }

  bool validateTimeRange() {
    if (startTime.value >= endTime.value) {
      Get.snackbar(
        'Invalid Time Range',
        'Start time must be less than end time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> applyFilters() async {
    if (!validateTimeRange()) return;

    try {
      isLoading.value = true;
      final date = selectedDate.value.toIso8601String().split('T')[0];
      final response = await APIService<Moisture>(
        fullUrl: '${APIConstant.baseCSUrl}/moisture/?plant_id=${plant?.id}page_size=$pageSize&date=$date&start_time=${startTime.value}&end_time=${endTime.value}&order=asc&plant_id=${plant.id}',
        allNoBearer: true,
      ).list();

      moistureData.value = response;
      filteredData.value = response;
      filteredData.value = sortMoistureRecords(filteredData.value);
    } catch (e) {
      print('Error fetching filtered moisture data: $e');
      Get.snackbar('Error', 'Failed to fetch filtered data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoistureData() async {
    try {
      isLoading.value = true;
      final date = selectedDate.value.toIso8601String().split('T')[0];
      final response = await APIService<Moisture>(
        fullUrl: '${APIConstant.baseCSUrl}/moisture/?page_size=$pageSize&date=$date&order=asc&plant_id=${plant.id}',
        allNoBearer: true,
      ).list();

      moistureData.value = response;
      filteredData.value = response;
      filteredData.value = sortMoistureRecords(filteredData.value);
    } catch (e) {
      print('Error fetching moisture data: $e');
      Get.snackbar('Error', 'Failed to fetch data');
    } finally {
      isLoading.value = false;
    }
  }

  List<Moisture> sortMoistureRecords(List<Moisture> records) {
    records.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) {
        return 0;
      } else if (a.createdAt == null) {
        return 1;
      } else if (b.createdAt == null) {
        return -1;
      } else {
        return a.createdAt!.compareTo(b.createdAt!);
      }
    });
    return records;
  }
}
