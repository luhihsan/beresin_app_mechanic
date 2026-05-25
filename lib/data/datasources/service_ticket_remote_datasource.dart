// lib/data/datasources/service_ticket_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/external_procurement_model.dart';
import '../models/service_ticket_model.dart';

/// Kontrak data source untuk mendefinisikan operasi database Firestore.
abstract class ServiceTicketRemoteDataSource {
  /// Aliran data realtime untuk memantau tiket berdasarkan ID Mekanik.
  Stream<List<ServiceTicketModel>> streamTicketsByMechanic(String mechanicId);

  /// Menambahkan pengadaan suku cadang luar secara atomik.
  Future<void> addExternalProcurement({
    required String documentId,
    required ExternalProcurementModel procurement,
  });

  Future<void> updateTicketStatus({required String documentId, required String status});
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
        data['id'] = doc.id; // Menyisipkan Document ID asli Firestore ke field objek
        return ServiceTicketModel.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> addExternalProcurement({
    required String documentId,
    required ExternalProcurementModel procurement,
  }) async {
    final docRef = _firestore.collection('serviceTickets').doc(documentId);

    // GOLDEN RULE: arrayUnion menjamin data tidak menimpa array lama (thread-safe)
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
}