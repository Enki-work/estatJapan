// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClassINF.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassINF _$ClassINFFromJson(Map<String, dynamic> json) {
  return ClassINF(
    CLASS_OBJ: (json['CLASS_OBJ'] as List<dynamic>)
        .map((e) => ClassOBJ.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ClassINFToJson(ClassINF instance) => <String, dynamic>{
      'CLASS_OBJ': instance.CLASS_OBJ,
    };
