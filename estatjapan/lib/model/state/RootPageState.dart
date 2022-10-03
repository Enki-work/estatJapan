import 'package:freezed_annotation/freezed_annotation.dart';

part 'RootPageState.freezed.dart';

@freezed
class RootPageState with _$RootPageState {
  const factory RootPageState({
    @Default(0) int selectedIndex,
  }) = _RootPageState;
}
