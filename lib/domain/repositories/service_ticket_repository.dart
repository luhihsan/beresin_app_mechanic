import 'dart:io';
import '../entities/external_procurement_entity.dart';
import '../entities/service_ticket_entity.dart';

abstract class ServiceTicketRepository {
  /// Aliran data penugasan servis mekanik secara realtime.
  Stream<List<ServiceTicketEntity>> getTicketsByMechanic(String mechanicId);

  /// Menambahkan nota pengadaan eksternal dengan dukungan unggah berkas fisik.
  Future<void> addExternalProcurement({
    required String ticketDocumentId,
    required String ticketId,
    required ExternalProcurementEntity procurement,
    required File? imageFile, // Mendukung berkas objek dari kamera native
  });

  /// Memperbarui status kemajuan servis kendaraan.
  Future<void> updateTicketStatus({required String ticketDocumentId, required String status});
}