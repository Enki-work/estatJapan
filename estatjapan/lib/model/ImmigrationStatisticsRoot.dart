// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'StatsData.dart';

part 'ImmigrationStatisticsRoot.g.dart';

@JsonSerializable()
class ImmigrationStatisticsRoot {
  final StatsData GET_STATS_DATA;
  ImmigrationStatisticsRoot({required this.GET_STATS_DATA});
  factory ImmigrationStatisticsRoot.fromJson(Map<String, dynamic> json) =>
      _$ImmigrationStatisticsRootFromJson(json);
  Map<String, dynamic> toJson() => _$ImmigrationStatisticsRootToJson(this);
}
