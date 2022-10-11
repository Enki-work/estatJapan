// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'RepositoryDataState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RepositoryDataState {
  int get selectedIndex => throw _privateConstructorUsedError;
  ImmigrationStatisticsRoot? get immigrationStatisticsRoot =>
      throw _privateConstructorUsedError;
  ImmigrationStatisticsRoot? get dataTableData =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RepositoryDataStateCopyWith<RepositoryDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepositoryDataStateCopyWith<$Res> {
  factory $RepositoryDataStateCopyWith(
          RepositoryDataState value, $Res Function(RepositoryDataState) then) =
      _$RepositoryDataStateCopyWithImpl<$Res>;
  $Res call(
      {int selectedIndex,
      ImmigrationStatisticsRoot? immigrationStatisticsRoot,
      ImmigrationStatisticsRoot? dataTableData});
}

/// @nodoc
class _$RepositoryDataStateCopyWithImpl<$Res>
    implements $RepositoryDataStateCopyWith<$Res> {
  _$RepositoryDataStateCopyWithImpl(this._value, this._then);

  final RepositoryDataState _value;
  // ignore: unused_field
  final $Res Function(RepositoryDataState) _then;

  @override
  $Res call({
    Object? selectedIndex = freezed,
    Object? immigrationStatisticsRoot = freezed,
    Object? dataTableData = freezed,
  }) {
    return _then(_value.copyWith(
      selectedIndex: selectedIndex == freezed
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      immigrationStatisticsRoot: immigrationStatisticsRoot == freezed
          ? _value.immigrationStatisticsRoot
          : immigrationStatisticsRoot // ignore: cast_nullable_to_non_nullable
              as ImmigrationStatisticsRoot?,
      dataTableData: dataTableData == freezed
          ? _value.dataTableData
          : dataTableData // ignore: cast_nullable_to_non_nullable
              as ImmigrationStatisticsRoot?,
    ));
  }
}

/// @nodoc
abstract class _$$_RepositoryDataStateStateCopyWith<$Res>
    implements $RepositoryDataStateCopyWith<$Res> {
  factory _$$_RepositoryDataStateStateCopyWith(
          _$_RepositoryDataStateState value,
          $Res Function(_$_RepositoryDataStateState) then) =
      __$$_RepositoryDataStateStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {int selectedIndex,
      ImmigrationStatisticsRoot? immigrationStatisticsRoot,
      ImmigrationStatisticsRoot? dataTableData});
}

/// @nodoc
class __$$_RepositoryDataStateStateCopyWithImpl<$Res>
    extends _$RepositoryDataStateCopyWithImpl<$Res>
    implements _$$_RepositoryDataStateStateCopyWith<$Res> {
  __$$_RepositoryDataStateStateCopyWithImpl(_$_RepositoryDataStateState _value,
      $Res Function(_$_RepositoryDataStateState) _then)
      : super(_value, (v) => _then(v as _$_RepositoryDataStateState));

  @override
  _$_RepositoryDataStateState get _value =>
      super._value as _$_RepositoryDataStateState;

  @override
  $Res call({
    Object? selectedIndex = freezed,
    Object? immigrationStatisticsRoot = freezed,
    Object? dataTableData = freezed,
  }) {
    return _then(_$_RepositoryDataStateState(
      selectedIndex: selectedIndex == freezed
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      immigrationStatisticsRoot: immigrationStatisticsRoot == freezed
          ? _value.immigrationStatisticsRoot
          : immigrationStatisticsRoot // ignore: cast_nullable_to_non_nullable
              as ImmigrationStatisticsRoot?,
      dataTableData: dataTableData == freezed
          ? _value.dataTableData
          : dataTableData // ignore: cast_nullable_to_non_nullable
              as ImmigrationStatisticsRoot?,
    ));
  }
}

/// @nodoc

class _$_RepositoryDataStateState implements _RepositoryDataStateState {
  const _$_RepositoryDataStateState(
      {this.selectedIndex = 0,
      this.immigrationStatisticsRoot,
      this.dataTableData});

  @override
  @JsonKey()
  final int selectedIndex;
  @override
  final ImmigrationStatisticsRoot? immigrationStatisticsRoot;
  @override
  final ImmigrationStatisticsRoot? dataTableData;

  @override
  String toString() {
    return 'RepositoryDataState(selectedIndex: $selectedIndex, immigrationStatisticsRoot: $immigrationStatisticsRoot, dataTableData: $dataTableData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RepositoryDataStateState &&
            const DeepCollectionEquality()
                .equals(other.selectedIndex, selectedIndex) &&
            const DeepCollectionEquality().equals(
                other.immigrationStatisticsRoot, immigrationStatisticsRoot) &&
            const DeepCollectionEquality()
                .equals(other.dataTableData, dataTableData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(selectedIndex),
      const DeepCollectionEquality().hash(immigrationStatisticsRoot),
      const DeepCollectionEquality().hash(dataTableData));

  @JsonKey(ignore: true)
  @override
  _$$_RepositoryDataStateStateCopyWith<_$_RepositoryDataStateState>
      get copyWith => __$$_RepositoryDataStateStateCopyWithImpl<
          _$_RepositoryDataStateState>(this, _$identity);
}

abstract class _RepositoryDataStateState implements RepositoryDataState {
  const factory _RepositoryDataStateState(
          {final int selectedIndex,
          final ImmigrationStatisticsRoot? immigrationStatisticsRoot,
          final ImmigrationStatisticsRoot? dataTableData}) =
      _$_RepositoryDataStateState;

  @override
  int get selectedIndex;
  @override
  ImmigrationStatisticsRoot? get immigrationStatisticsRoot;
  @override
  ImmigrationStatisticsRoot? get dataTableData;
  @override
  @JsonKey(ignore: true)
  _$$_RepositoryDataStateStateCopyWith<_$_RepositoryDataStateState>
      get copyWith => throw _privateConstructorUsedError;
}
