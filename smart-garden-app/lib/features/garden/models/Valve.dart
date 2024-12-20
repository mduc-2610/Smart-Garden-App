
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Valve {
  final String? id;
  final String? plantId;
  final bool? isOpen;
  final DateTime? createdAt;

  Valve({
    this.id,
    this.plantId,
    this.isOpen,
    dynamic createdAt,
  }) : createdAt = THelperFunction.parseToDateTime(createdAt);

  Valve.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        plantId = json['plant_id'],
        isOpen = json['is_open'] as bool?,
        createdAt = THelperFunction.parseDateNormalize(json['created_at']);

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'plant_id': plantId,
      'is_open': isOpen,
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