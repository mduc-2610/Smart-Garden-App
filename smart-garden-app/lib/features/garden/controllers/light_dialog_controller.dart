import 'package:food_delivery_app/features/garden/controllers/time_controller.dart';
import 'package:get/get.dart';

class LightDialogController extends GetxController {
  static LightDialogController get instance => Get.find();
  final RxBool _defaultSettings = false.obs;
  bool get defaultSettings => _defaultSettings.value;
  set defaultSettings(bool value) => _defaultSettings.value = value;

  final TimeController startTimeController = Get.put(TimeController(), tag:"start_light");
  final TimeController endTimeController = Get.put(TimeController(), tag:"end_light");

  void saveSettings() {
    // Implement save logic here
    print('Saving settings...');
    print('Start Time: ${startTimeController.hour}:${startTimeController.minute.toString().padLeft(2, '0')} ${startTimeController.period}');
    print('End Time: ${endTimeController.hour}:${endTimeController.minute.toString().padLeft(2, '0')} ${endTimeController.minute}');
  }
}