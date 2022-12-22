// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClassOBJ.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassOBJ _$ClassOBJFromJson(Map<String, dynamic> json) => ClassOBJ(
      id: json['@id'] as String,
      name: json['@name'] as String,
      CLASS: ClassOBJ._getOptionalClass(json['CLASS']),
    );

Map<String, dynamic> _$ClassOBJToJson(ClassOBJ instance) => <String, dynamic>{
      '@id': instance.id,
      '@name': instance.name,
      'CLASS': instance.CLASS,
    };
