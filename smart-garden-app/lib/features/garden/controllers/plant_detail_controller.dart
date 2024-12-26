import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_garden_app/data/services/api_service.dart';
import 'dart:convert';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/utils/constants/times.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class PlantDetailController extends GetxController {
  var isOpen = false.obs;
  var isLoading = true.obs;
  var isValveAuto = true.obs;
  Timer? _timer;
  var plant = Rx<Plant?>(null);
  String? plantId;
  Map<String, dynamic> autoState = {};

  PlantDetailController();

  @override
  void onInit() {
    super.onInit();
    plantId = Get.arguments['id'];
    fetchValveState();
    fetchPlantDetails();
    fetchValveAutoState();
    startRealTimeUpdates();
  }

  Future<void> fetchPlantDetails() async {
    try {
      $print("Hello");
      final response = await APIService<Plant>(
        fullUrl: '${APIConstant.baseCSUrl}/plant',
        allNoBearer: true,
      ).retrieve(plantId!);
      await Future.delayed(const Duration(milliseconds: TTime.init));
      plant.value = response;
        } catch (e) {
      print('Error fetching plant details: $e');
      Get.snackbar('Error', 'Failed to load plant data');
    } finally {
      isLoading.value = false;
    }
  }

  void startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (isValveAuto.value) {
        fetchValveState();
      }
    });
  }

  void toggleOpen(bool value) async {
    isOpen.value = value;

    try {
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/valve/${plant.value?.id}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'is_open': isOpen.value,
        }),
      );

      if (response.statusCode == 200) {
        print("Valve state updated successfully");
      } else {
        print('Error toggling valve: ${response.body}');
        isOpen.value = !value;
        Get.snackbar(
          'Error',
          'Failed to update valve state',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error toggling valve: $e');
      isOpen.value = !value;
      Get.snackbar(
        'Error',
        'Failed to update valve state',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleValveAuto(bool value) async {
    isValveAuto.value = value;

    try {

      if(plant.value?.valve == 1) {
        autoState['valve_1'] = isValveAuto.value;
      }
      else {
        autoState['valve_2'] = isValveAuto.value;
      }
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/auto"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(autoState),
      );

      if (response.statusCode == 200) {
        print("Auto valve state updated successfully");
      } else {
        print('Error toggling auto valve: ${response.body}');
        isValveAuto.value = !value;
        Get.snackbar(
          'Error',
          'Failed to update auto valve state',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error toggling auto valve: $e');
      isValveAuto.value = !value;
      Get.snackbar(
        'Error',
        'Failed to update auto valve state',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchValveState() async {
    try {
      final response = await http.get(
          Uri.parse("${APIConstant.baseEsp32Url}/valve/${plant.value?.id}")
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.containsKey('is_open')) {
          isOpen.value = data['is_open'];
        } else {
          print('Invalid response structure: $data');
        }
      } else {
        print('Error fetching valve state: ${response.body}');
      }
    } catch (e) {
      print('Error fetching valve state: $e');
    }
  }

  Future<void> fetchValveAutoState() async {
    try {
      final response = await http.get(
          Uri.parse("${APIConstant.baseEsp32Url}/auto")
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        autoState = data;
      } else {
        print('Error fetching valve auto state: ${response.body}');
      }
    } catch (e) {
      print('Error fetching valve auto state: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}