// lib/domain/repositories/service_ticket_repository.dart
import '../entities/external_procurement_entity.dart';
import '../entities/service_ticket_entity.dart';

/// Kontrak repositori untuk memisahkan logika bisnis (Domain) 
/// dari detail infrastruktur data (Data Layer).
abstract class ServiceTicketRepository {
  /// Mengambil semua tiket servis yang ditugaskan khusus untuk mekanik tertentu.
  Stream<List<ServiceTicketEntity>> getTicketsByMechanic(String mechanicId);

  /// Menambahkan pengadaan suku cadang luar secara atomik dan aman (Anti-Overwrite).
  Future<void> addExternalProcurement({
    required String ticketDocumentId,
    required ExternalProcurementEntity procurement,
  });
}