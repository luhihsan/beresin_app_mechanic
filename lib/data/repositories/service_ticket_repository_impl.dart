// lib/data/repositories/service_ticket_repository_impl.dart
import 'package:injectable/injectable.dart';
import '../../domain/entities/external_procurement_entity.dart';
import '../../domain/entities/service_ticket_entity.dart';
import '../../domain/repositories/service_ticket_repository.dart';
import '../datasources/service_ticket_remote_datasource.dart';
import '../models/external_procurement_model.dart';

@LazySingleton(as: ServiceTicketRepository)
class ServiceTicketRepositoryImpl implements ServiceTicketRepository {
  final ServiceTicketRemoteDataSource _remoteDataSource;

  ServiceTicketRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ServiceTicketEntity>> getTicketsByMechanic(String mechanicId) {
    return _remoteDataSource
        .streamTicketsByMechanic(mechanicId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> addExternalProcurement({
    required String ticketDocumentId,
    required ExternalProcurementEntity procurement,
  }) async {
    // Mengonversi business entity menjadi DTO sebelum dilempar ke data source
    final model = ExternalProcurementModel.fromEntity(procurement);
    
    await _remoteDataSource.addExternalProcurement(
      documentId: ticketDocumentId,
      procurement: model,
    );
  }

  @override
  Future<void> updateTicketStatus({required String ticketDocumentId, required String status}) async {
    await _remoteDataSource.updateTicketStatus(
      documentId: ticketDocumentId,
      status: status,
    );
  }
}