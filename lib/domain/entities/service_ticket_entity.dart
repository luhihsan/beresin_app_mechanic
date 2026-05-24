// lib/domain/entities/service_ticket_entity.dart
import 'external_procurement_entity.dart';

class ServiceTicketEntity {
  final String id;
  final String ticketId;
  final String customerId;
  final String vehicleId;
  final String mechanicId;
  final int kmCheckIn;
  final int kmService;
  final String tasks;
  final String status; // "waiting" | "processing" | "completed"
  final DateTime date;
  final DateTime createdAt;
  final List<ExternalProcurementEntity> externalProcurements;

  const ServiceTicketEntity({
    required this.id,
    required this.ticketId,
    required this.customerId,
    required this.vehicleId,
    required this.mechanicId,
    required this.kmCheckIn,
    required this.kmService,
    required this.tasks,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.externalProcurements,
  });
}