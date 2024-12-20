
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Light {
  final String? id;
  final bool? isLight;
  final DateTime? createdAt;

  Light({
    this.id,
    this.isLight,
    dynamic createdAt,
  }) : createdAt = THelperFunction.parseToDateTime(createdAt);

  Light.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        isLight = json['is_light'] as bool?,
        createdAt = THelperFunction.parseDateNormalize(json['created_at']);

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'is_light': isLight,
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
