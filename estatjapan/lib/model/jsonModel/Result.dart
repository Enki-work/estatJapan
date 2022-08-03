// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'Result.g.dart';

@JsonSerializable()
class Result {
  final int STATUS;
  final String ERROR_MSG;
  final String DATE;
  Result({required this.STATUS, required this.ERROR_MSG, required this.DATE});
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
