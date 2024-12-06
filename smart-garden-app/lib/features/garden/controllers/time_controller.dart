import 'package:get/get.dart';

class TimeController extends GetxController {
  static TimeController get instance => Get.find();

  final RxInt _hour = 8.obs;
  int get hour => _hour.value;
  set hour(int value) => _hour.value = value;

  final RxInt _minute = 0.obs;
  int get minute => _minute.value;
  set minute(int value) => _minute.value = value;

  final RxString _period = "AM".obs;
  String get period => _period.value;
  set period(String value) => _period.value = value;

  final RxBool _showTime = false.obs;
  bool get showTime => _showTime.value;
  set showTime(bool value) => _showTime.value = value;

  void toggleShowTime() {
    _showTime.value = !_showTime.value;
  }

  void incrementHour({bool isStartTime = true}) {
    hour = hour == 12 ? 1 : hour + 1;
  }

  void decrementHour({bool isStartTime = true}) {
    _hour.value = _hour.value == 1 ? 12 : hour - 1;
  }

  void incrementMinute({bool isStartTime = true}) {
    _minute.value = (_minute.value + 1) % 60;
  }

  void decrementMinute({bool isStartTime = true}) {
    _minute.value = _minute.value == 0 ? 59 : _minute.value - 1;
  }

  void togglePeriod({bool isStartTime = true}) {
    _period.value = _period.value == "AM" ? "PM" : "AM";
  }

  void onHourChanged(value) => hour = value;
  void onMinuteChanged(value) => minute = value;
  void onPeriodChanged(value) => period = value;
}
