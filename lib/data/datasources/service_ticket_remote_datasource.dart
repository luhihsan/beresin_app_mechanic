// lib/data/datasources/service_ticket_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/external_procurement_model.dart';
import '../models/service_ticket_model.dart';

abstract class ServiceTicketRemoteDataSource {
  Stream<List<ServiceTicketModel>> streamTicketsByMechanic(String mechanicId);
  Future<void> addExternalProcurement({
    required String documentId,
    required ExternalProcurementModel procurement,
  });
  Future<void> updateTicketStatus({required String documentId, required String status});
  
  // BARU: Kontrak untuk menyelesaikan tugas montir secara terintegrasi
  Future<void> completeTicketTask({
    required String documentId,
    required int kmService,
    required int invoiceAmount,
  });
}

@LazySingleton(as: ServiceTicketRemoteDataSource)
class ServiceTicketRemoteDataSourceImpl implements ServiceTicketRemoteDataSource {
  final FirebaseFirestore _firestore;

  ServiceTicketRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<ServiceTicketModel>> streamTicketsByMechanic(String mechanicId) {
    return _firestore
        .collection('serviceTickets')
        .where('mechanicId', isEqualTo: mechanicId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // FIX ERROR: Mengirimkan data JSON map beserta doc.id asli Firestore secara manual
        return ServiceTicketModel.fromJson(data, doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addExternalProcurement({
    required String documentId,
    required ExternalProcurementModel procurement,
  }) async {
    final docRef = _firestore.collection('serviceTickets').doc(documentId);
    await docRef.update({
      'externalProcurements': FieldValue.arrayUnion([
        procurement.toJson(),
      ]),
    });
  }

  @override
  Future<void> updateTicketStatus({required String documentId, required String status}) async {
    await _firestore.collection('serviceTickets').doc(documentId).update({
      'status': status,
    });
  }

  @override
  Future<void> completeTicketTask({
    required String documentId,
    required int kmService,
    required int invoiceAmount,
  }) async {
    await _firestore.collection('serviceTickets').doc(documentId).update({
      'status': 'completed',
      'kmService': kmService,
      'invoiceAmount': invoiceAmount,
    });
  }
}