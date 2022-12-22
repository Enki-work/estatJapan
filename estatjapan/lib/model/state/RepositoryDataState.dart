import 'package:freezed_annotation/freezed_annotation.dart';

import '../jsonModel/ImmigrationStatisticsRoot.dart';

part 'RepositoryDataState.freezed.dart';

@freezed
class RepositoryDataState with _$RepositoryDataState {
  const factory RepositoryDataState({
    @Default(0) int selectedIndex,
    ImmigrationStatisticsRoot? immigrationStatisticsRoot,
    ImmigrationStatisticsRoot? dataTableData,
  }) = _RepositoryDataStateState;
}
