// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceTicketModelImpl _$$ServiceTicketModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceTicketModelImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      customerId: json['customerId'] as String,
      vehicleId: json['vehicleId'] as String,
      mechanicId: json['mechanicId'] as String,
      kmCheckIn: (json['kmCheckIn'] as num).toInt(),
      kmService: (json['kmService'] as num).toInt(),
      tasks: json['tasks'] as String,
      status: json['status'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      externalProcurements: (json['externalProcurements'] as List<dynamic>)
          .map((e) =>
              ExternalProcurementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ServiceTicketModelImplToJson(
        _$ServiceTicketModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'customerId': instance.customerId,
      'vehicleId': instance.vehicleId,
      'mechanicId': instance.mechanicId,
      'kmCheckIn': instance.kmCheckIn,
      'kmService': instance.kmService,
      'tasks': instance.tasks,
      'status': instance.status,
      'date': const TimestampConverter().toJson(instance.date),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'externalProcurements': instance.externalProcurements,
    };
