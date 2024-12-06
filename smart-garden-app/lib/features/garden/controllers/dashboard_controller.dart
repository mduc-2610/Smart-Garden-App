import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLightOn = false.obs;
  var isPumpOn = false.obs;
  var isRoofOpen = false.obs;

  void toggleLight(bool value) {
    isLightOn.value = value;
  }

  void togglePump(bool value) {
    isPumpOn.value = value;
  }

  void toggleRoof(bool value) {
    isRoofOpen.value = value;
  }
}
