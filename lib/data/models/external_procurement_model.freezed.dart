// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_procurement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExternalProcurementModel _$ExternalProcurementModelFromJson(
    Map<String, dynamic> json) {
  return _ExternalProcurementModel.fromJson(json);
}

/// @nodoc
mixin _$ExternalProcurementModel {
  String get partName => throw _privateConstructorUsedError;
  String get supplierStore => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError;
  String get receiptPhotoUrl => throw _privateConstructorUsedError;

  /// Serializes this ExternalProcurementModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExternalProcurementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExternalProcurementModelCopyWith<ExternalProcurementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalProcurementModelCopyWith<$Res> {
  factory $ExternalProcurementModelCopyWith(ExternalProcurementModel value,
          $Res Function(ExternalProcurementModel) then) =
      _$ExternalProcurementModelCopyWithImpl<$Res, ExternalProcurementModel>;
  @useResult
  $Res call(
      {String partName,
      String supplierStore,
      int cost,
      String receiptPhotoUrl});
}

/// @nodoc
class _$ExternalProcurementModelCopyWithImpl<$Res,
        $Val extends ExternalProcurementModel>
    implements $ExternalProcurementModelCopyWith<$Res> {
  _$ExternalProcurementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExternalProcurementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partName = null,
    Object? supplierStore = null,
    Object? cost = null,
    Object? receiptPhotoUrl = null,
  }) {
    return _then(_value.copyWith(
      partName: null == partName
          ? _value.partName
          : partName // ignore: cast_nullable_to_non_nullable
              as String,
      supplierStore: null == supplierStore
          ? _value.supplierStore
          : supplierStore // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      receiptPhotoUrl: null == receiptPhotoUrl
          ? _value.receiptPhotoUrl
          : receiptPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExternalProcurementModelImplCopyWith<$Res>
    implements $ExternalProcurementModelCopyWith<$Res> {
  factory _$$ExternalProcurementModelImplCopyWith(
          _$ExternalProcurementModelImpl value,
          $Res Function(_$ExternalProcurementModelImpl) then) =
      __$$ExternalProcurementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String partName,
      String supplierStore,
      int cost,
      String receiptPhotoUrl});
}

/// @nodoc
class __$$ExternalProcurementModelImplCopyWithImpl<$Res>
    extends _$ExternalProcurementModelCopyWithImpl<$Res,
        _$ExternalProcurementModelImpl>
    implements _$$ExternalProcurementModelImplCopyWith<$Res> {
  __$$ExternalProcurementModelImplCopyWithImpl(
      _$ExternalProcurementModelImpl _value,
      $Res Function(_$ExternalProcurementModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExternalProcurementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partName = null,
    Object? supplierStore = null,
    Object? cost = null,
    Object? receiptPhotoUrl = null,
  }) {
    return _then(_$ExternalProcurementModelImpl(
      partName: null == partName
          ? _value.partName
          : partName // ignore: cast_nullable_to_non_nullable
              as String,
      supplierStore: null == supplierStore
          ? _value.supplierStore
          : supplierStore // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      receiptPhotoUrl: null == receiptPhotoUrl
          ? _value.receiptPhotoUrl
          : receiptPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExternalProcurementModelImpl extends _ExternalProcurementModel {
  const _$ExternalProcurementModelImpl(
      {required this.partName,
      required this.supplierStore,
      required this.cost,
      required this.receiptPhotoUrl})
      : super._();

  factory _$ExternalProcurementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExternalProcurementModelImplFromJson(json);

  @override
  final String partName;
  @override
  final String supplierStore;
  @override
  final int cost;
  @override
  final String receiptPhotoUrl;

  @override
  String toString() {
    return 'ExternalProcurementModel(partName: $partName, supplierStore: $supplierStore, cost: $cost, receiptPhotoUrl: $receiptPhotoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalProcurementModelImpl &&
            (identical(other.partName, partName) ||
                other.partName == partName) &&
            (identical(other.supplierStore, supplierStore) ||
                other.supplierStore == supplierStore) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.receiptPhotoUrl, receiptPhotoUrl) ||
                other.receiptPhotoUrl == receiptPhotoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, partName, supplierStore, cost, receiptPhotoUrl);

  /// Create a copy of ExternalProcurementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalProcurementModelImplCopyWith<_$ExternalProcurementModelImpl>
      get copyWith => __$$ExternalProcurementModelImplCopyWithImpl<
          _$ExternalProcurementModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExternalProcurementModelImplToJson(
      this,
    );
  }
}

abstract class _ExternalProcurementModel extends ExternalProcurementModel {
  const factory _ExternalProcurementModel(
      {required final String partName,
      required final String supplierStore,
      required final int cost,
      required final String receiptPhotoUrl}) = _$ExternalProcurementModelImpl;
  const _ExternalProcurementModel._() : super._();

  factory _ExternalProcurementModel.fromJson(Map<String, dynamic> json) =
      _$ExternalProcurementModelImpl.fromJson;

  @override
  String get partName;
  @override
  String get supplierStore;
  @override
  int get cost;
  @override
  String get receiptPhotoUrl;

  /// Create a copy of ExternalProcurementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExternalProcurementModelImplCopyWith<_$ExternalProcurementModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
