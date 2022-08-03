import 'package:json_annotation/json_annotation.dart';

import 'Value.dart';

part 'DataINF.g.dart';

@JsonSerializable()
class DataINF {
  final List<Value> VALUE;
  DataINF({required this.VALUE});
  factory DataINF.fromJson(Map<String, dynamic> json) =>
      _$DataINFFromJson(json);
  Map<String, dynamic> toJson() => _$DataINFToJson(this);
}
