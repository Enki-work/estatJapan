// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'PurchaseModelApi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PurchaseModel {
  bool get isPurchase => throw _privateConstructorUsedError;
  bool get isUsedTrial => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PurchaseModelCopyWith<PurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseModelCopyWith<$Res> {
  factory $PurchaseModelCopyWith(
          PurchaseModel value, $Res Function(PurchaseModel) then) =
      _$PurchaseModelCopyWithImpl<$Res>;
  $Res call({bool isPurchase, bool isUsedTrial});
}

/// @nodoc
class _$PurchaseModelCopyWithImpl<$Res>
    implements $PurchaseModelCopyWith<$Res> {
  _$PurchaseModelCopyWithImpl(this._value, this._then);

  final PurchaseModel _value;
  // ignore: unused_field
  final $Res Function(PurchaseModel) _then;

  @override
  $Res call({
    Object? isPurchase = freezed,
    Object? isUsedTrial = freezed,
  }) {
    return _then(_value.copyWith(
      isPurchase: isPurchase == freezed
          ? _value.isPurchase
          : isPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isUsedTrial: isUsedTrial == freezed
          ? _value.isUsedTrial
          : isUsedTrial // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_PurchaseModelCopyWith<$Res>
    implements $PurchaseModelCopyWith<$Res> {
  factory _$$_PurchaseModelCopyWith(
          _$_PurchaseModel value, $Res Function(_$_PurchaseModel) then) =
      __$$_PurchaseModelCopyWithImpl<$Res>;
  @override
  $Res call({bool isPurchase, bool isUsedTrial});
}

/// @nodoc
class __$$_PurchaseModelCopyWithImpl<$Res>
    extends _$PurchaseModelCopyWithImpl<$Res>
    implements _$$_PurchaseModelCopyWith<$Res> {
  __$$_PurchaseModelCopyWithImpl(
      _$_PurchaseModel _value, $Res Function(_$_PurchaseModel) _then)
      : super(_value, (v) => _then(v as _$_PurchaseModel));

  @override
  _$_PurchaseModel get _value => super._value as _$_PurchaseModel;

  @override
  $Res call({
    Object? isPurchase = freezed,
    Object? isUsedTrial = freezed,
  }) {
    return _then(_$_PurchaseModel(
      isPurchase: isPurchase == freezed
          ? _value.isPurchase
          : isPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isUsedTrial: isUsedTrial == freezed
          ? _value.isUsedTrial
          : isUsedTrial // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PurchaseModel implements _PurchaseModel {
  const _$_PurchaseModel({this.isPurchase = false, this.isUsedTrial = false});

  @override
  @JsonKey()
  final bool isPurchase;
  @override
  @JsonKey()
  final bool isUsedTrial;

  @override
  String toString() {
    return 'PurchaseModel(isPurchase: $isPurchase, isUsedTrial: $isUsedTrial)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PurchaseModel &&
            const DeepCollectionEquality()
                .equals(other.isPurchase, isPurchase) &&
            const DeepCollectionEquality()
                .equals(other.isUsedTrial, isUsedTrial));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isPurchase),
      const DeepCollectionEquality().hash(isUsedTrial));

  @JsonKey(ignore: true)
  @override
  _$$_PurchaseModelCopyWith<_$_PurchaseModel> get copyWith =>
      __$$_PurchaseModelCopyWithImpl<_$_PurchaseModel>(this, _$identity);

  @override
  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['isPurchase'] = isPurchase;
    pigeonMap['isUsedTrial'] = isUsedTrial;
    return pigeonMap;
  }
}

abstract class _PurchaseModel implements PurchaseModel {
  const factory _PurchaseModel(
      {final bool isPurchase, final bool isUsedTrial}) = _$_PurchaseModel;

  @override
  bool get isPurchase;
  @override
  bool get isUsedTrial;
  @override
  @JsonKey(ignore: true)
  _$$_PurchaseModelCopyWith<_$_PurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
