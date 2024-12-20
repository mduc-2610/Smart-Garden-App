import 'package:smart_garden_app/features/garden/controllers/time_controller.dart';
import 'package:get/get.dart';

class WaterCustomizeController extends GetxController {
  final RxBool _defaultSettings = false.obs;
  bool get defaultSettings => _defaultSettings.value;
  set defaultSettings(bool value) => _defaultSettings.value = value;

  final RxDouble _pumpTimer = 8.0.obs;
  double get pumpTimer => _pumpTimer.value;
  set pumpTimer(double value) => _pumpTimer.value = value;

  final RxInt _pumpOnMinutes = 1.obs;
  int get pumpOnMinutes => _pumpOnMinutes.value;
  set pumpOnMinutes(int value) => _pumpOnMinutes.value = value;

  final RxInt _pumpRestHours = 1.obs;
  int get pumpRestHours => _pumpRestHours.value;
  set pumpRestHours(int value) => _pumpRestHours.value = value;

  final TimeController startTimeController = Get.put(TimeController(), tag:"start");
  final TimeController endTimeController = Get.put(TimeController(), tag:"end");

  void saveSettings() {
    // Implement save logic here
    print('Saving settings...');
    print('Start Time: ${startTimeController.hour}:${startTimeController.minute.toString().padLeft(2, '0')} ${startTimeController.period}');
    print('End Time: ${endTimeController.hour}:${endTimeController.minute.toString().padLeft(2, '0')} ${endTimeController.minute}');
  }
}