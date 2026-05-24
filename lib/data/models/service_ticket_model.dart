// lib/data/models/service_ticket_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/service_ticket_entity.dart';
import 'external_procurement_model.dart';

part 'service_ticket_model.freezed.dart';
part 'service_ticket_model.g.dart';

/// Helper serializer kustom untuk mengonversi Cloud Firestore Timestamp ke DateTime secara aman
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

@freezed
class ServiceTicketModel with _$ServiceTicketModel {
  const factory ServiceTicketModel({
    required String id,
    required String ticketId,
    required String customerId,
    required String vehicleId,
    required String mechanicId,
    required int kmCheckIn,
    required int kmService,
    required String tasks,
    required String status,
    @TimestampConverter() required DateTime date,
    @TimestampConverter() required DateTime createdAt,
    required List<ExternalProcurementModel> externalProcurements,
  }) = _ServiceTicketModel;

  const ServiceTicketModel._();

  factory ServiceTicketModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceTicketModelFromJson(json);

  /// Mapping dari Data Model ke Domain Entity
  ServiceTicketEntity toEntity() {
    return ServiceTicketEntity(
      id: id,
      ticketId: ticketId,
      customerId: customerId,
      vehicleId: vehicleId,
      mechanicId: mechanicId,
      kmCheckIn: kmCheckIn,
      kmService: kmService,
      tasks: tasks,
      status: status,
      date: date,
      createdAt: createdAt,
      externalProcurements: externalProcurements.map((e) => e.toEntity()).toList(),
    );
  }

  /// Mapping dari Domain Entity ke Data Model DTO
  factory ServiceTicketModel.fromEntity(ServiceTicketEntity entity) {
    return ServiceTicketModel(
      id: entity.id,
      ticketId: entity.ticketId,
      customerId: entity.customerId,
      vehicleId: entity.vehicleId,
      mechanicId: entity.mechanicId,
      kmCheckIn: entity.kmCheckIn,
      kmService: entity.kmService,
      tasks: entity.tasks,
      status: entity.status,
      date: entity.date,
      createdAt: entity.createdAt,
      externalProcurements: entity.externalProcurements
          .map((e) => ExternalProcurementModel.fromEntity(e))
          .toList(),
    );
  }
}