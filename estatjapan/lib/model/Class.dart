import 'package:json_annotation/json_annotation.dart';

part 'Class.g.dart';

@JsonSerializable()
class Class {
  @JsonKey(name: "@code")
  final String code;
  @JsonKey(name: "@name")
  final String name;
  @JsonKey(name: "@level")
  final String level;
  @JsonKey(name: "@parentCode")
  final String? parentCode;
  @JsonKey(name: "@unit")
  final String? unit;
  Class(
      {required this.code,
      required this.name,
      required this.level,
      this.parentCode,
      this.unit});
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);
  Map<String, dynamic> toJson() => _$ClassToJson(this);
}
