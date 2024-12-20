
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class Dht11 {
  final String? id;
  final double? temperature;
  final double? humidity;
  final DateTime? createdAt;

  Dht11({
    this.id,
    this.temperature,
    this.humidity,
    dynamic createdAt,
  }) : createdAt = THelperFunction.parseToDateTime(createdAt);

  Dht11.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        temperature = (json['temperature'] as num?)?.toDouble(),
        humidity = (json['humidity'] as num?)?.toDouble(),
        createdAt = THelperFunction.parseDateNormalize(json['created_at']);

  Map<String, dynamic> toJson({bool patch = false}) {
    final data = {
      'temperature': temperature,
      'humidity': humidity,
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

