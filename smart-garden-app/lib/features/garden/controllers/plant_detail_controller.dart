import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';

class PlantDetailController extends GetxController {
  final Plant plant;
  var isOpen = false.obs;
  var isValveAuto = true.obs;
  Timer? _timer;

  PlantDetailController({required this.plant});

  @override
  void onInit() {
    super.onInit();
    fetchValveState();
    fetchValveAutoState();
    startRealTimeUpdates();
  }

  void startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      if (isValveAuto.value) {
        fetchValveState();
      }
    });
  }

  void toggleOpen(bool value) async {
    isOpen.value = value;

    try {
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/valve/${plant.id}"),
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
        // Revert the state if the request failed
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
      // Revert the state if the request failed
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
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/auto"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'valve_${plant.id}': isValveAuto.value,
        }),
      );

      if (response.statusCode == 200) {
        print("Auto valve state updated successfully");
      } else {
        print('Error toggling auto valve: ${response.body}');
        // Revert the state if the request failed
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
      // Revert the state if the request failed
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
          Uri.parse("${APIConstant.baseEsp32Url}/valve/${plant.id}")
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
        if (data.containsKey('valve_${plant.id}')) {
          isValveAuto.value = data['valve_${plant.id}'];
        } else {
          print('Invalid response structure: $data');
        }
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