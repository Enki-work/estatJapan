// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataINF.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataINF _$DataINFFromJson(Map<String, dynamic> json) {
  return DataINF(
    VALUE: (json['VALUE'] as List<dynamic>)
        .map((e) => Value.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DataINFToJson(DataINF instance) => <String, dynamic>{
      'VALUE': instance.VALUE,
    };
