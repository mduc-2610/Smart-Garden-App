import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

@reflector
@jsonSerializable
class VerifyOTP {
  final String code;
  final String user;
  final bool isLogin;

  VerifyOTP({
    required this.code,
    required this.user,
    required this.isLogin,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'user': user,
      'is_login': isLogin,
    };
  }

  @override
  String toString() {
    return THelperFunction.formatToString(this);
  }
}
