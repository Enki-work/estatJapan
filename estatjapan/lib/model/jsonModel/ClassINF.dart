// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'ClassOBJ.dart';

part 'ClassINF.g.dart';

@JsonSerializable()
class ClassINF {
  final List<ClassOBJ> CLASS_OBJ;
  ClassINF({required this.CLASS_OBJ});
  factory ClassINF.fromJson(Map<String, dynamic> json) =>
      _$ClassINFFromJson(json);
  Map<String, dynamic> toJson() => _$ClassINFToJson(this);
}
