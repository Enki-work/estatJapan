import 'package:json_annotation/json_annotation.dart';

import 'ClassINF.dart';
import 'ResultINF.dart';

part 'StatisticalData.g.dart';

@JsonSerializable()
class StatisticalData {
  final ResultINF RESULT_INF;
  final ClassINF CLASS_INF;
  StatisticalData({required this.RESULT_INF, required this.CLASS_INF});
  factory StatisticalData.fromJson(Map<String, dynamic> json) =>
      _$StatisticalDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatisticalDataToJson(this);
}
