// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'ResultINF.g.dart';

@JsonSerializable()
class ResultINF {
  final int TOTAL_NUMBER;
  ResultINF({required this.TOTAL_NUMBER});
  factory ResultINF.fromJson(Map<String, dynamic> json) =>
      _$ResultINFFromJson(json);
  Map<String, dynamic> toJson() => _$ResultINFToJson(this);
}
