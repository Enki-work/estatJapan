// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Class _$ClassFromJson(Map<String, dynamic> json) => Class(
      code: json['@code'] as String,
      name: json['@name'] as String,
      level: json['@level'] as String,
      parentCode: json['@parentCode'] as String?,
      unit: json['@unit'] as String?,
    )..parentID = json['parentID'] as String?;

Map<String, dynamic> _$ClassToJson(Class instance) => <String, dynamic>{
      '@code': instance.code,
      '@name': instance.name,
      '@level': instance.level,
      '@parentCode': instance.parentCode,
      '@unit': instance.unit,
      'parentID': instance.parentID,
    };
