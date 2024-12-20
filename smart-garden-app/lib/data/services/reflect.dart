import 'package:reflectable/reflectable.dart';
import 'package:reflectable/reflectable.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class JsonSerializable extends Reflectable {
  const JsonSerializable()
      : super(invokingCapability, declarationsCapability, typingCapability);
}

const jsonSerializable = JsonSerializable();

class Reflector extends Reflectable {
  const Reflector()
      : super(
      instanceInvokeCapability,
      declarationsCapability,
      superclassQuantifyCapability,
      subtypeQuantifyCapability,
      typeRelationsCapability,
      typingCapability);
}

const reflector = Reflector();
