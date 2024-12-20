
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Moisture {
  final String? id;
  final String? plantId;
  final double? moisture;
  final DateTime? createdAt;

  Moisture({
    this.id,
    this.plantId,
    this.moisture,
    dynamic createdAt,
  }) : createdAt = THelperFunction.parseToDateTime(createdAt);

  Moisture.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        plantId = json['plant_id'],
        moisture = (json['moisture'] as num?)?.toDouble(),
        createdAt = THelperFunction.parseDateNormalize(json['created_at']);

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'plant_id': plantId,
      'moisture': moisture,
      'created_at': createdAt?.toUtc().toIso8601String(),
    };

    if (patch) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  @override
  String toString() => THelperFunction.formatToString(this);
}
