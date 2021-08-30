// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Value _$ValueFromJson(Map<String, dynamic> json) {
  return Value(
    tab: json['@tab'] as String,
    cat01: json['@cat01'] as String,
    cat02: json['@cat02'] as String,
    cat03: json['@cat03'] as String?,
    time: json['@time'] as String?,
    unit: json['@unit'] as String?,
    value: json[r'$'] as String?,
  );
}

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      '@tab': instance.tab,
      '@cat01': instance.cat01,
      '@cat02': instance.cat02,
      '@cat03': instance.cat03,
      '@time': instance.time,
      '@unit': instance.unit,
      r'$': instance.value,
    };
