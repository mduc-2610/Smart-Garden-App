import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/features/garden/models/Dht11.dart';
import 'package:smart_garden_app/data/services/api_service.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardController extends GetxController {
  var isPumpOn = false.obs;
  var isRoofOpen = false.obs;
  var isLoading = true.obs;
  var dht11Data = <Dht11>[].obs;
  var filteredData = <Dht11>[].obs;
  var selectedDate = DateTime.now().obs;
  var startTime = 0.obs;
  var endTime = 24.obs;
  int pageSize = 300;
  var selectedTimeFormat = 'HH:mm:ss'.obs;
  String apiKey = "46518dbdb84d55ff7cace213a59c51f3";
  var hanoiTemperature = "--".obs;
  var hanoiHumidity = "--".obs;
  var hanoiWindSpeed = "--".obs;
  var isLight = false.obs;
  var isLedAuto = true.obs;

  Timer? _timer;

  void setTimeFormat(String format) {
    selectedTimeFormat.value = format;
    fetchDht11Data();
  }

  void toggleLight(bool value) async {
    isLight.value = value;

    try {
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/light"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'is_light': isLight.value,
        }),
      );

      if (response.statusCode == 200) {
        print("Light state updated successfully");
      } else {
        print('Error toggling light: ${response.body}');
      }
    } catch (e) {
      print('Error toggling light: $e');
    }
  }

  void toggleLedAuto(bool value) async {
    isLedAuto.value = value;

    try {
      final response = await http.post(
        Uri.parse("${APIConstant.baseEsp32Url}/auto"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'valve_1': true,
          'valve_2': true,
          'led': isLedAuto.value,
        }),
      );

      if (response.statusCode == 200) {
        print("Auto light state updated successfully");
      } else {
        print('Error toggling auto light: ${response.body}');
      }
    } catch (e) {
      print('Error toggling auto light: $e');
    }
  }

  void togglePump(bool value) => isPumpOn.value = value;
  void toggleRoof(bool value) => isRoofOpen.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchHanoiWeather();
    fetchLightState();
    fetchLightAutoState();
    fetchDht11Data();
    startRealTimeUpdates();
  }

  void startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchHanoiWeather();
      if(isLedAuto.value) {
        fetchLightState();
      }
    });
  }

  Future<void> fetchHanoiWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=Hanoi&units=metric&appid=$apiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        hanoiTemperature.value = "${data['main']['temp']}°C";
        hanoiHumidity.value = "${data['main']['humidity']}%";
        hanoiWindSpeed.value = "${data['wind']['speed']}m/s";
      } else {
        print('Error fetching Hanoi weather: ${response.body}');
      }
    } catch (e) {
      print('Error fetching Hanoi weather: $e');
    }
  }

  Future<void> fetchLightState() async {
    try {
      final response = await http.get(Uri.parse("${APIConstant.baseEsp32Url}/light"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        $print("Light State $data ");
        if (data.containsKey('is_light')) {
          isLight.value = data['is_light'];
          $print("TYPE ${data['is_light'].runtimeType}");
        } else {
          print('Invalid response structure: $data');
        }
      } else {
        print('Error fetching light state: ${response.body}');
      }
    } catch (e) {
      print('Error fetching light state: $e');
    }
  }

  Future<void> fetchLightAutoState() async {
    try {
      final response = await http.get(Uri.parse("${APIConstant.baseEsp32Url}/auto"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        $print("Light Auto State $data ");
        if (data.containsKey('led')) {
          isLedAuto.value = data['led'];
          $print("TYPE ${data['led'].runtimeType}");
        } else {
          print('Invalid response structure: $data');
        }
      } else {
        print('Error fetching light state: ${response.body}');
      }
    } catch (e) {
      print('Error fetching light state: $e');
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
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
      final response = await APIService<Dht11>(
        fullUrl: '${APIConstant.baseCSUrl}/dht11/?page_size=$pageSize&date=$date&start_time=${startTime.value}&end_time=${endTime.value}&order=asc',
        allNoBearer: true,
      ).list();

      dht11Data.value = response;
      filteredData.value = response;
      filteredData.value = sortDht11Records(filteredData.value);
    } catch (e) {
      print('Error fetching filtered data: $e');
      Get.snackbar('Error', 'Failed to fetch filtered data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDht11Data() async {
    try {
      isLoading.value = true;
      final date = selectedDate.value.toIso8601String().split('T')[0];
      final response = await APIService<Dht11>(
        fullUrl: '${APIConstant.baseCSUrl}/dht11/?page_size=$pageSize&date=$date&order=asc',
        allNoBearer: true,
      ).list();

      dht11Data.value = response;
      filteredData.value = response;
      filteredData.value = sortDht11Records(filteredData.value);
    } catch (e) {
      print('Error fetching data: $e');
      Get.snackbar('Error', 'Failed to fetch data');
    } finally {
      isLoading.value = false;
    }
  }

  List<Dht11> sortDht11Records(List<Dht11> dht11Records) {
    dht11Records.sort((a, b) {
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
    return dht11Records;
  }
}
