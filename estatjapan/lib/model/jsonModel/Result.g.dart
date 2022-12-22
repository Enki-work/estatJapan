// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      STATUS: json['STATUS'] as int,
      ERROR_MSG: json['ERROR_MSG'] as String,
      DATE: json['DATE'] as String,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'STATUS': instance.STATUS,
      'ERROR_MSG': instance.ERROR_MSG,
      'DATE': instance.DATE,
    };
