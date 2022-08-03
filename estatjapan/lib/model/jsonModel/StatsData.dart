import 'package:json_annotation/json_annotation.dart';

import 'Result.dart';
import 'StatisticalData.dart';

part 'StatsData.g.dart';

@JsonSerializable()
class StatsData {
  final Result RESULT;
  final StatisticalData STATISTICAL_DATA;
  StatsData({required this.RESULT, required this.STATISTICAL_DATA});
  factory StatsData.fromJson(Map<String, dynamic> json) =>
      _$StatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatsDataToJson(this);
}
