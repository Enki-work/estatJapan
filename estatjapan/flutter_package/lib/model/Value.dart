import 'package:json_annotation/json_annotation.dart';

part 'Value.g.dart';

@JsonSerializable()
class Value {
  @JsonKey(name: "@tab")
  final String tab;
  @JsonKey(name: "@cat01")
  final String cat01;
  @JsonKey(name: "@cat02")
  final String cat02;
  @JsonKey(name: "@cat03")
  final String? cat03;
  @JsonKey(name: "@time")
  final String? time;
  @JsonKey(name: "@unit")
  final String? unit;
  @JsonKey(name: "\$")
  final String? value;
  Value(
      {required this.tab,
      required this.cat01,
      required this.cat02,
      required this.cat03,
      required this.time,
      required this.unit,
      required this.value});
  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
