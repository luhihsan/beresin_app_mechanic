// lib/domain/entities/service_ticket_entity.dart
import 'car_details_entity.dart';
import 'external_procurement_entity.dart';

class ServiceTicketEntity {
  final String id;
  final String ticketId;
  final String customerId;
  final String vehicleId;
  final String customerUid;
  final String mechanicId;
  final String mechanicName;
  final int kmCheckIn;
  final int kmService;
  final int invoiceAmount;
  final String tasks;
  final String status;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? targetCompletionTime; 
  final List<String> complaintPhotoUrls;
  final List<ExternalProcurementEntity> externalProcurements;
  final CarDetailsEntity carDetails;

  const ServiceTicketEntity({
    required this.id,
    required this.ticketId,
    required this.customerId,
    required this.vehicleId,
    required this.customerUid,
    required this.mechanicId,
    required this.mechanicName,
    required this.kmCheckIn,
    required this.kmService,
    required this.invoiceAmount,
    required this.tasks,
    required this.status,
    required this.date,
    required this.createdAt,
    this.targetCompletionTime,
    required this.complaintPhotoUrls,
    required this.externalProcurements,
    required this.carDetails,
  });
}