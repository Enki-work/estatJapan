// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatisticalData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticalData _$StatisticalDataFromJson(Map<String, dynamic> json) {
  return StatisticalData(
    RESULT_INF: ResultINF.fromJson(json['RESULT_INF'] as Map<String, dynamic>),
    CLASS_INF: ClassINF.fromJson(json['CLASS_INF'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatisticalDataToJson(StatisticalData instance) =>
    <String, dynamic>{
      'RESULT_INF': instance.RESULT_INF,
      'CLASS_INF': instance.CLASS_INF,
    };
