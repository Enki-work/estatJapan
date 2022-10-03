import 'package:freezed_annotation/freezed_annotation.dart';

import '../jsonModel/ImmigrationStatisticsRoot.dart';

part 'RootPageState.freezed.dart';

@freezed
class RootPageState with _$RootPageState {
  const factory RootPageState({
    @Default(0) int selectedIndex,
    ImmigrationStatisticsRoot? immigrationStatisticsRoot,
  }) = _RootPageState;
}
