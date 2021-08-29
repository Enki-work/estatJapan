import 'package:estatjapan/model/Result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'StatsData.g.dart';

@JsonSerializable()
class StatsData {
  final Result RESULT;
  // final String PARAMETER;
  // final String STATISTICAL_DATA;
  StatsData({required this.RESULT
      //   ,
      // required this.PARAMETER,
      // required this.STATISTICAL_DATA
      });
  factory StatsData.fromJson(Map<String, dynamic> json) =>
      _$StatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatsDataToJson(this);
}
