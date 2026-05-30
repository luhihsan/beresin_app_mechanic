// lib/data/models/service_ticket_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service_ticket_entity.dart';
import 'car_details_model.dart';
import 'external_procurement_model.dart';

class ServiceTicketModel {
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
  final DateTime? targetCompletionTime; // BARU
  final List<String> complaintPhotoUrls;
  final List<ExternalProcurementModel> externalProcurements;
  final CarDetailsModel carDetails;

  const ServiceTicketModel({
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

  factory ServiceTicketModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ServiceTicketModel(
      id: documentId,
      ticketId: json['ticketId'] ?? '',
      customerId: json['customerId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      customerUid: json['customerUid'] ?? '',
      mechanicId: json['mechanicId'] ?? '',
      mechanicName: json['mechanicName'] ?? '',
      kmCheckIn: json['kmCheckIn'] ?? 0,
      kmService: json['kmService'] ?? 0,
      invoiceAmount: json['invoiceAmount'] ?? 0,
      tasks: json['tasks'] ?? '',
      status: json['status'] ?? 'waiting',
      date: (json['date'] is Timestamp) ? (json['date'] as Timestamp).toDate() : DateTime.now(),
      createdAt: (json['createdAt'] is Timestamp) ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
      targetCompletionTime: (json['targetCompletionTime'] is Timestamp) ? (json['targetCompletionTime'] as Timestamp).toDate() : null,
      complaintPhotoUrls: List<String>.from(json['complaintPhotoUrls'] ?? []),
      externalProcurements: (json['externalProcurements'] as List?)
              ?.map((e) => ExternalProcurementModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      carDetails: CarDetailsModel.fromJson(json['carDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'customerId': customerId,
      'vehicleId': vehicleId,
      'customerUid': customerUid,
      'mechanicId': mechanicId,
      'mechanicName': mechanicName,
      'kmCheckIn': kmCheckIn,
      'kmService': kmService,
      'invoiceAmount': invoiceAmount,
      'tasks': tasks,
      'status': status,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'targetCompletionTime': targetCompletionTime != null ? Timestamp.fromDate(targetCompletionTime!) : null,
      'complaintPhotoUrls': complaintPhotoUrls,
      'externalProcurements': externalProcurements.map((e) => e.toJson()).toList(),
      'carDetails': carDetails.toJson(),
    };
  }

  ServiceTicketEntity toEntity() {
    return ServiceTicketEntity(
      id: id,
      ticketId: ticketId,
      customerId: customerId,
      vehicleId: vehicleId,
      customerUid: customerUid,
      mechanicId: mechanicId,
      mechanicName: mechanicName,
      kmCheckIn: kmCheckIn,
      kmService: kmService,
      invoiceAmount: invoiceAmount,
      tasks: tasks,
      status: status,
      date: date,
      createdAt: createdAt,
      targetCompletionTime: targetCompletionTime,
      complaintPhotoUrls: complaintPhotoUrls,
      externalProcurements: externalProcurements.map((e) => e.toEntity()).toList(),
      carDetails: carDetails.toEntity(),
    );
  }

  factory ServiceTicketModel.fromEntity(ServiceTicketEntity entity) {
    return ServiceTicketModel(
      id: entity.id,
      ticketId: entity.ticketId,
      customerId: entity.customerId,
      vehicleId: entity.vehicleId,
      customerUid: entity.customerUid,
      mechanicId: entity.mechanicId,
      mechanicName: entity.mechanicName,
      kmCheckIn: entity.kmCheckIn,
      kmService: entity.kmService,
      invoiceAmount: entity.invoiceAmount,
      tasks: entity.tasks,
      status: entity.status,
      date: entity.date,
      createdAt: entity.createdAt,
      complaintPhotoUrls: entity.complaintPhotoUrls,
      externalProcurements: entity.externalProcurements
          .map((e) => ExternalProcurementModel.fromEntity(e))
          .toList(),
      carDetails: CarDetailsModel.fromEntity(entity.carDetails),
    );
  }
}