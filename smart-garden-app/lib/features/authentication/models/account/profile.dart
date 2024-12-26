import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class UserProfile {
  final String? user;
  final String? name;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? avatar;

  UserProfile({
    this.user,
    this.name,
    this.gender,
    dynamic dateOfBirth,
    this.avatar,
  }) : dateOfBirth = THelperFunction.parseToDateTime(dateOfBirth);

  UserProfile.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        name = json['name'],
        gender = json['gender'],
        avatar = json['avatar'],
        dateOfBirth = THelperFunction.parseDateNormalize(json['date_of_birth']);

  Map<String, dynamic> toJson({bool patch = false}) {
    final Map<String, dynamic> data = {
      'user': user,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toUtc().toIso8601String(),
    };

    if (patch) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  @override
  String toString() {
    return THelperFunction.formatToString(this);
  }
}
