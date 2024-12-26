import 'package:reflectable/reflectable.dart';

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
