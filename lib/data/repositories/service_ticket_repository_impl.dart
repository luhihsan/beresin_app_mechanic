// lib/data/repositories/service_ticket_repository_impl.dart
import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/external_procurement_entity.dart';
import '../../domain/entities/service_ticket_entity.dart';
import '../../domain/repositories/service_ticket_repository.dart';
import '../datasources/service_ticket_remote_datasource.dart';
import '../datasources/storage_remote_datasource.dart';
import '../models/external_procurement_model.dart';

@LazySingleton(as: ServiceTicketRepository)
class ServiceTicketRepositoryImpl implements ServiceTicketRepository {
  final ServiceTicketRemoteDataSource _remoteDataSource;
  final StorageRemoteDataSource _storageRemoteDataSource;

  ServiceTicketRepositoryImpl(this._remoteDataSource, this._storageRemoteDataSource);

  @override
  Stream<List<ServiceTicketEntity>> getTicketsByMechanic(String mechanicId) {
    return _remoteDataSource
        .streamTicketsByMechanic(mechanicId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> addExternalProcurement({
    required String ticketDocumentId,
    required String ticketId,
    required ExternalProcurementEntity procurement,
    required File? imageFile,
  }) async {
    String finalPhotoUrl = procurement.receiptPhotoUrl;

    if (imageFile != null) {
      finalPhotoUrl = await _storageRemoteDataSource.uploadReceiptImage(
        ticketId: ticketId,
        imageFile: imageFile,
      );
    }

    final updatedProcurement = ExternalProcurementEntity(
      partName: procurement.partName,
      supplierStore: procurement.supplierStore,
      cost: procurement.cost,
      receiptPhotoUrl: finalPhotoUrl,
    );

    final model = ExternalProcurementModel.fromEntity(updatedProcurement);
    
    await _remoteDataSource.addExternalProcurement(
      documentId: ticketDocumentId,
      procurement: model,
    );
  }

  @override
  Future<void> updateTicketStatus({required String ticketDocumentId, required String status}) async {
    await _remoteDataSource.updateTicketStatus(documentId: ticketDocumentId, status: status);
  }

  @override
  Future<void> completeTicketTask({
    required String ticketDocumentId,
    required int kmService,
    required int invoiceAmount,
  }) async {
    await _remoteDataSource.completeTicketTask(
      documentId: ticketDocumentId,
      kmService: kmService,
      invoiceAmount: invoiceAmount,
    );
  }
}