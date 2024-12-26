import 'package:smart_garden_app/data/services/api_service.dart';
import 'package:smart_garden_app/features/garden/controllers/time_controller.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class WaterCustomizeController extends GetxController {
  static WaterCustomizeController get instance => Get.find();
  final Plant? plant;

  WaterCustomizeController({ required this.plant });

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

  late final TimeController startTimeController;
  late final TimeController pumpTimeController;

  @override
  void onInit() {
    super.onInit();
    startTimeController = Get.put(TimeController(
      timeString: plant?.startTime,
      showTime: true
    ), tag:"start_${plant?.id}");
    pumpTimeController = Get.put(TimeController(
        timeString: plant?.durationTime,
        showTime: true
    ), tag:"pump_${plant?.id}");
  }

  Future<void> saveSettings() async {
    // Implement save logic here
    print('Saving settings...');
    print('Start Time: ${startTimeController.toResult(TimeFormat.HHMM, showPeriod: true)}');
    print('End Time: ${pumpTimeController.toResult(TimeFormat.HHMMSS)}');

    plant?.startTime = startTimeController.toResult(TimeFormat.HHMM, showPeriod: true);
    plant?.durationTime = pumpTimeController.toResult(TimeFormat.HHMMSS);
    $print(plant?.name);
    $print(plant?.description);
    $print(plant);
    final response = await APIService<Plant>(
        // fullUrl: '${APIConstant.baseCSUrl}/plant/${plant?.id}'
      allNoBearer: true
    ).update(plant?.id, plant);
    $print('Response: $response');
    Get.back();
  }
}