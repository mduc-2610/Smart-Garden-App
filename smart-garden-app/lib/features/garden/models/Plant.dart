import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Plant {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final String? imageUrl;
  final int? waterDaysPerWeek;
  final int? plantDays;
  final int? lightPercentPerDay;
  final int? valve;
  bool? isAuto;
  String? startTime;
  String? durationTime;
  Map<String, bool>? wateringDays;

  Plant({
    this.id,
    this.name,
    this.description,
    dynamic createdAt,
    this.isAuto,
    this.imageUrl,
    this.waterDaysPerWeek,
    this.plantDays,
    this.lightPercentPerDay,
    this.valve,
    this.startTime,
    this.durationTime,
    this.wateringDays,
  }) : createdAt = THelperFunction.parseToDateTime(createdAt);

  Plant.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'],
        description = json['description'],
        createdAt = THelperFunction.parseDateNormalize(json['created_at']),
        isAuto = json['is_auto'] as bool?,
        imageUrl = json['image_url'],
        waterDaysPerWeek = json['water_days_per_week'],
        plantDays = json['plant_days'],
        lightPercentPerDay = json['light_percent_per_day'],
        valve = json['valve'],
        startTime = json['start_time'],
        durationTime = json['duration_time'],
        wateringDays = (json['watering_days'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, value as bool),
        );

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'name': name,
      'description': description,
      'is_auto': isAuto,
      'image_url': imageUrl,
      'water_days_per_week': waterDaysPerWeek,
      'plant_days': plantDays,
      'light_percent_per_day': lightPercentPerDay,
      'start_time': startTime,
      'duration_time': durationTime,
      'watering_days': wateringDays,
    };

    if (patch) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

  bool shouldWaterToday() {
    if (wateringDays == null) return false;
    final today = DateTime.now().weekday;
    final dayName = _getDayName(today);
    return wateringDays![dayName] ?? false;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        throw ArgumentError('Invalid weekday');
    }
  }

  @override
  String toString() => THelperFunction.formatToString(this);
}