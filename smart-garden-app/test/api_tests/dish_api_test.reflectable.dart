// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.
import 'dart:core';
import 'package:food_delivery_app/data/services/reflect.dart' as prefix0;

// ignore_for_file: camel_case_types
// ignore_for_file: implementation_imports
// ignore_for_file: prefer_adjacent_string_concatenation
// ignore_for_file: prefer_collection_literals
// ignore_for_file: unnecessary_const
// ignore_for_file: unused_import

import 'package:reflectable/mirrors.dart' as m;
import 'package:reflectable/src/reflectable_builder_based.dart' as r;
import 'package:reflectable/reflectable.dart' as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.JsonSerializable(): r.ReflectorData(
      <m.TypeMirror>[],
      <m.DeclarationMirror>[],
      <m.ParameterMirror>[],
      <Type>[],
      0,
      {},
      {},
      <m.LibraryMirror>[],
      []),
  const prefix0.Reflector(): r.ReflectorData(
      <m.TypeMirror>[],
      <m.DeclarationMirror>[],
      <m.ParameterMirror>[],
      <Type>[],
      0,
      {},
      {},
      <m.LibraryMirror>[],
      [])
};

final _memberSymbolMap = null;

void initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
