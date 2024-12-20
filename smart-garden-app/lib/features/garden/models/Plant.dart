
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Plant {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final bool? isAuto;
  final String? imageUrl;
  final int? waterDaysPerWeek;
  final int? plantDays;
  final int? lightPercentPerDay;

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
        lightPercentPerDay = json['light_percent_per_day'];

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'name': name,
      'description': description,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'is_auto': isAuto,
    };

    if (patch) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  @override
  String toString() => THelperFunction.formatToString(this);
}
