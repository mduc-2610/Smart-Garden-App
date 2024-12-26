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
  Map<String, dynamic> valveState = {};
  PlantDetailController();

  @override
  void onInit() {
    super.onInit();
    plantId = Get.arguments['id'];
    fetchValveState();
    startRealTimeUpdates();
    fetchValveAutoState();
    fetchPlantDetails();
  }

  Future<void> fetchPlantDetails() async {
    try {
      final response = await APIService<Plant>(
        fullUrl: '${APIConstant.baseCSUrl}/plant',
        allNoBearer: true,
      ).retrieve(plantId!);
      await Future.delayed(const Duration(milliseconds: TTime.init));
      plant.value = response;
      isValveAuto.value = plant?.value?.isAuto ?? true;
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
      valveState["valve_${plant?.value?.valve}"] = isOpen.value;

      $print("Valve update: $valveState");
      final response = await http.post(
        Uri.parse("${await APIConstant.buildBaseEsp32Url()}/valve"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(valveState),
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

  Future<bool> _updateValveAutoStateOnESP32(bool value, int valveNumber) async {
    try {
      autoState["valve_${valveNumber}"] = value;
      $print("Update state $autoState");

      final response = await http.post(
        Uri.parse("${await APIConstant.buildBaseEsp32Url()}/valve/auto"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(autoState),
      );

      if (response.statusCode == 200) {
        print("Auto valve state updated successfully on ESP32");
        return true;
      } else {
        print('Error updating ESP32: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating ESP32: $e');
      return false;
    }
  }

  Future<bool> _updatePlantAutoState(Plant plant, bool value) async {
    try {
      plant.isAuto = value;
      final response = await APIService<Plant>(allNoBearer: true).update(
          plant.id,
          plant
      );

      print(response);
      return true;
    } catch (e) {
      print('Error updating plant: $e');
      return false;
    }
  }

  void toggleValveAuto(bool value) async {
    isValveAuto.value = value;

    final valveNumber = plant.value?.valve == 1 ? 1 : 2;

    final esp32Success = await _updateValveAutoStateOnESP32(value, valveNumber);
    final plantSuccess = await _updatePlantAutoState(plant.value!, value);

    if (!esp32Success || !plantSuccess) {
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
          Uri.parse("${await APIConstant.buildBaseEsp32Url()}/valve")
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        valveState = data;
        $print("Valve init: $valveState");
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
          Uri.parse("${await APIConstant.buildBaseEsp32Url()}/valve/auto")
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        autoState = data;
        $print("Init state $autoState");
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