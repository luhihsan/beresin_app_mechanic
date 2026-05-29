// lib/domain/repositories/service_ticket_repository.dart
import 'dart:io';
import '../entities/external_procurement_entity.dart';
import '../entities/service_ticket_entity.dart';

abstract class ServiceTicketRepository {
  Stream<List<ServiceTicketEntity>> getTicketsByMechanic(String mechanicId);
  Future<void> addExternalProcurement({
    required String ticketDocumentId,
    required String ticketId,
    required ExternalProcurementEntity procurement,
    required File? imageFile,
  });
  Future<void> updateTicketStatus({required String ticketDocumentId, required String status});
  
  // BARU
  Future<void> completeTicketTask({
    required String ticketDocumentId,
    required int kmService,
    required int invoiceAmount,
  });
}