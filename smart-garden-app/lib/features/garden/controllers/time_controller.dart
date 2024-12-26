import 'package:get/get.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class TimeController extends GetxController {
  static TimeController get instance => Get.find();

  TimeController({
    int? hour,
    int? minute,
    int? second,
    String? timeString,
    String period = "AM",
    bool showTime = true,
  }) {
    _period.value = period;

    if (timeString != null) {
      setTimeFromString(timeString);
    } else {
      this.hour = hour ?? 8;
      this.minute = minute ?? 0;
      this.second = second ?? 0;
      this.period = period;
      this.showTime = showTime;
    }
  }

  final RxInt _hour = 8.obs;
  int get hour => _hour.value;
  set hour(int value) => _hour.value = value % 12;

  final RxInt _minute = 0.obs;
  int get minute => _minute.value;
  set minute(int value) => _minute.value = value;

  final RxInt _second = 0.obs;
  int get second => _second.value;
  set second(int value) => _second.value = value;

  final RxString _period = "AM".obs;
  String get period => _period.value;
  set period(String value) => _period.value = value;

  final RxBool _showTime = true.obs;
  bool get showTime => _showTime.value;
  set showTime(bool value) => _showTime.value = value;

  int get totalSeconds {
    int hrs = hour;
    if (period == "PM" && hrs != 12) hrs += 12;
    if (period == "AM" && hrs == 12) hrs = 0;
    return hrs * 3600 + minute * 60 + second;
  }

  int get totalMinutes => _minute.value;

  void toggleShowTime() {
    _showTime.value = !_showTime.value;
  }

  void incrementHour({bool isStartTime = true}) {
    hour = (hour + 1) % 12;
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

  void incrementSecond({bool isStartTime = true}) {
    _second.value = (_second.value + 1) % 60;
  }

  void decrementSecond({bool isStartTime = true}) {
    _second.value = _second.value == 0 ? 59 : _second.value - 1;
  }

  void togglePeriod({bool isStartTime = true}) {
    _period.value = _period.value == "AM" ? "PM" : "AM";
  }

  void onHourChanged(value) => hour = value;
  void onMinuteChanged(value) => minute = value;
  void onSecondChanged(value) => second = value;
  void onPeriodChanged(value) => period = value;

  void onTotalSecondsChanged(int totalSeconds) {
    int hrs = totalSeconds ~/ 3600;
    int mins = (totalSeconds % 3600) ~/ 60;
    int secs = totalSeconds % 60;

    if (hrs >= 12) {
      period = "PM";
      if (hrs > 12) hrs -= 12;
    } else {
      period = "AM";
      if (hrs == 0) hrs = 12;
    }

    hour = hrs;
    minute = mins;
    second = secs;
    update();
  }

  void onTotalMinutesChanged(int totalMinutes) {
    int hrs = totalMinutes ~/ 60;
    int mins = totalMinutes % 60;

    if (hrs >= 12) {
      period = "PM";
      if (hrs > 12) hrs -= 12;
    } else {
      period = "AM";
      if (hrs == 0) hrs = 12;
    }

    hour = hrs;
    minute = mins;
  }

  void setTimeFromString(String timeString) {
    timeString = timeString.trim();

    bool hasPeriod = timeString.contains("AM") || timeString.contains("PM");
    if (hasPeriod) {
      List<String> parts = timeString.split(" ");
      String time = parts[0];
      // period = parts[1];
      _period.value = parts[1];
      $print("Set period $period");
      _setTimeFromString(time);
    } else {
      _setTimeFromString(timeString);
    }
    $print("Final period $period");

    update();
  }

  void _setTimeFromString(String timeString) {
    List<String> timeParts = timeString.split(":");

    int hrs = 0;
    int mins = 0;
    int secs = 0;

    if (timeParts.isNotEmpty) {
      hrs = int.tryParse(timeParts[0]) ?? 0;
    }
    if (timeParts.length > 1) {
      mins = int.tryParse(timeParts[1]) ?? 0;
    }
    if (timeParts.length > 2) {
      secs = int.tryParse(timeParts[2]) ?? 0;
    }

    hour = hrs;
    minute = mins;
    second = secs;
    $print("Hour: $hour - Minute: $minute - Second: $second");

    // if (hrs >= 12) {
    //   period = "PM";
    //   if (hrs > 12) hrs -= 12;
    // } else {
    //   period = "AM";
    //   if (hrs == 0) hrs = 12;
    // }

    hour = hrs;
  }


  String toResult(TimeFormat format, {bool showPeriod = false}) {
    String formattedTime = '';

    switch (format) {
      case TimeFormat.HHMM:
        formattedTime = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        break;
      case TimeFormat.HHMMSS:
        formattedTime = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
        break;
      case TimeFormat.MMSS:
        formattedTime = "${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
        break;
      case TimeFormat.SS:
        formattedTime = "${second.toString().padLeft(2, '0')}";
        break;
    }

    if (showPeriod) {
      formattedTime += " $period";
    }

    return formattedTime;
  }
}
