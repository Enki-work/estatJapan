// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'ClassINF.dart';
import 'DataINF.dart';
import 'ResultINF.dart';

part 'StatisticalData.g.dart';

@JsonSerializable()
class StatisticalData {
  final ResultINF RESULT_INF;
  final ClassINF CLASS_INF;
  final DataINF DATA_INF;

  StatisticalData(
      {required this.RESULT_INF,
      required this.CLASS_INF,
      required this.DATA_INF});
  factory StatisticalData.fromJson(Map<String, dynamic> json) =>
      _$StatisticalDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatisticalDataToJson(this);
}
