// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_ticket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceTicketModel _$ServiceTicketModelFromJson(Map<String, dynamic> json) {
  return _ServiceTicketModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceTicketModel {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get mechanicId => throw _privateConstructorUsedError;
  int get kmCheckIn => throw _privateConstructorUsedError;
  int get kmService => throw _privateConstructorUsedError;
  String get tasks => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ExternalProcurementModel> get externalProcurements =>
      throw _privateConstructorUsedError;

  /// Serializes this ServiceTicketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTicketModelCopyWith<ServiceTicketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTicketModelCopyWith<$Res> {
  factory $ServiceTicketModelCopyWith(
          ServiceTicketModel value, $Res Function(ServiceTicketModel) then) =
      _$ServiceTicketModelCopyWithImpl<$Res, ServiceTicketModel>;
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String customerId,
      String vehicleId,
      String mechanicId,
      int kmCheckIn,
      int kmService,
      String tasks,
      String status,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime createdAt,
      List<ExternalProcurementModel> externalProcurements});
}

/// @nodoc
class _$ServiceTicketModelCopyWithImpl<$Res, $Val extends ServiceTicketModel>
    implements $ServiceTicketModelCopyWith<$Res> {
  _$ServiceTicketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? customerId = null,
    Object? vehicleId = null,
    Object? mechanicId = null,
    Object? kmCheckIn = null,
    Object? kmService = null,
    Object? tasks = null,
    Object? status = null,
    Object? date = null,
    Object? createdAt = null,
    Object? externalProcurements = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      mechanicId: null == mechanicId
          ? _value.mechanicId
          : mechanicId // ignore: cast_nullable_to_non_nullable
              as String,
      kmCheckIn: null == kmCheckIn
          ? _value.kmCheckIn
          : kmCheckIn // ignore: cast_nullable_to_non_nullable
              as int,
      kmService: null == kmService
          ? _value.kmService
          : kmService // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      externalProcurements: null == externalProcurements
          ? _value.externalProcurements
          : externalProcurements // ignore: cast_nullable_to_non_nullable
              as List<ExternalProcurementModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceTicketModelImplCopyWith<$Res>
    implements $ServiceTicketModelCopyWith<$Res> {
  factory _$$ServiceTicketModelImplCopyWith(_$ServiceTicketModelImpl value,
          $Res Function(_$ServiceTicketModelImpl) then) =
      __$$ServiceTicketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String customerId,
      String vehicleId,
      String mechanicId,
      int kmCheckIn,
      int kmService,
      String tasks,
      String status,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime createdAt,
      List<ExternalProcurementModel> externalProcurements});
}

/// @nodoc
class __$$ServiceTicketModelImplCopyWithImpl<$Res>
    extends _$ServiceTicketModelCopyWithImpl<$Res, _$ServiceTicketModelImpl>
    implements _$$ServiceTicketModelImplCopyWith<$Res> {
  __$$ServiceTicketModelImplCopyWithImpl(_$ServiceTicketModelImpl _value,
      $Res Function(_$ServiceTicketModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? customerId = null,
    Object? vehicleId = null,
    Object? mechanicId = null,
    Object? kmCheckIn = null,
    Object? kmService = null,
    Object? tasks = null,
    Object? status = null,
    Object? date = null,
    Object? createdAt = null,
    Object? externalProcurements = null,
  }) {
    return _then(_$ServiceTicketModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      mechanicId: null == mechanicId
          ? _value.mechanicId
          : mechanicId // ignore: cast_nullable_to_non_nullable
              as String,
      kmCheckIn: null == kmCheckIn
          ? _value.kmCheckIn
          : kmCheckIn // ignore: cast_nullable_to_non_nullable
              as int,
      kmService: null == kmService
          ? _value.kmService
          : kmService // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      externalProcurements: null == externalProcurements
          ? _value._externalProcurements
          : externalProcurements // ignore: cast_nullable_to_non_nullable
              as List<ExternalProcurementModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceTicketModelImpl extends _ServiceTicketModel {
  const _$ServiceTicketModelImpl(
      {required this.id,
      required this.ticketId,
      required this.customerId,
      required this.vehicleId,
      required this.mechanicId,
      required this.kmCheckIn,
      required this.kmService,
      required this.tasks,
      required this.status,
      @TimestampConverter() required this.date,
      @TimestampConverter() required this.createdAt,
      required final List<ExternalProcurementModel> externalProcurements})
      : _externalProcurements = externalProcurements,
        super._();

  factory _$ServiceTicketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTicketModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String customerId;
  @override
  final String vehicleId;
  @override
  final String mechanicId;
  @override
  final int kmCheckIn;
  @override
  final int kmService;
  @override
  final String tasks;
  @override
  final String status;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  final List<ExternalProcurementModel> _externalProcurements;
  @override
  List<ExternalProcurementModel> get externalProcurements {
    if (_externalProcurements is EqualUnmodifiableListView)
      return _externalProcurements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_externalProcurements);
  }

  @override
  String toString() {
    return 'ServiceTicketModel(id: $id, ticketId: $ticketId, customerId: $customerId, vehicleId: $vehicleId, mechanicId: $mechanicId, kmCheckIn: $kmCheckIn, kmService: $kmService, tasks: $tasks, status: $status, date: $date, createdAt: $createdAt, externalProcurements: $externalProcurements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTicketModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.mechanicId, mechanicId) ||
                other.mechanicId == mechanicId) &&
            (identical(other.kmCheckIn, kmCheckIn) ||
                other.kmCheckIn == kmCheckIn) &&
            (identical(other.kmService, kmService) ||
                other.kmService == kmService) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._externalProcurements, _externalProcurements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ticketId,
      customerId,
      vehicleId,
      mechanicId,
      kmCheckIn,
      kmService,
      tasks,
      status,
      date,
      createdAt,
      const DeepCollectionEquality().hash(_externalProcurements));

  /// Create a copy of ServiceTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTicketModelImplCopyWith<_$ServiceTicketModelImpl> get copyWith =>
      __$$ServiceTicketModelImplCopyWithImpl<_$ServiceTicketModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTicketModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceTicketModel extends ServiceTicketModel {
  const factory _ServiceTicketModel(
          {required final String id,
          required final String ticketId,
          required final String customerId,
          required final String vehicleId,
          required final String mechanicId,
          required final int kmCheckIn,
          required final int kmService,
          required final String tasks,
          required final String status,
          @TimestampConverter() required final DateTime date,
          @TimestampConverter() required final DateTime createdAt,
          required final List<ExternalProcurementModel> externalProcurements}) =
      _$ServiceTicketModelImpl;
  const _ServiceTicketModel._() : super._();

  factory _ServiceTicketModel.fromJson(Map<String, dynamic> json) =
      _$ServiceTicketModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get customerId;
  @override
  String get vehicleId;
  @override
  String get mechanicId;
  @override
  int get kmCheckIn;
  @override
  int get kmService;
  @override
  String get tasks;
  @override
  String get status;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  List<ExternalProcurementModel> get externalProcurements;

  /// Create a copy of ServiceTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTicketModelImplCopyWith<_$ServiceTicketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
