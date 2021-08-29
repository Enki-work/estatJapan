// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsData _$StatsDataFromJson(Map<String, dynamic> json) {
  return StatsData(
    RESULT: Result.fromJson(json['RESULT'] as Map<String, dynamic>),
    STATISTICAL_DATA: StatisticalData.fromJson(
        json['STATISTICAL_DATA'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatsDataToJson(StatsData instance) => <String, dynamic>{
      'RESULT': instance.RESULT,
      'STATISTICAL_DATA': instance.STATISTICAL_DATA,
    };
