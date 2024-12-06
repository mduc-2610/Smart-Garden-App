import 'package:food_delivery_app/data/services/reflect.dart';
import 'package:food_delivery_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Plant {
  final String name;
  final String imageUrl;
  final int waterDaysPerWeek;
  final int lightPercentPerDay;
  final int plantDays;

  Plant({
    required this.name,
    required this.imageUrl,
    required this.waterDaysPerWeek,
    required this.lightPercentPerDay,
    required this.plantDays,
  });

  Plant.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      imageUrl = json['image_url'],
      waterDaysPerWeek = json['water_days_per_week'],
      lightPercentPerDay = json['light_percent_per_day'],
      plantDays = json['plant_days'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'name': name,
      'image_url': imageUrl,
      'water_days_per_week': waterDaysPerWeek,
      'light_percent_per_day': lightPercentPerDay,
    };
    return data;
  }

  @override
  String toString() {
    return THelperFunction.formatToString(this);
  }
}
