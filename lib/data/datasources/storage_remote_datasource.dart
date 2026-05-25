// lib/data/datasources/storage_remote_datasource.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

abstract class StorageRemoteDataSource {
  /// Mengunggah berkas gambar nota ke path 'receipts/TICKET_ID/timestamp.jpg'
  /// Mengembalikan tautan unduhan (Download URL) berupa String.
  Future<String> uploadReceiptImage({required String ticketId, required File imageFile});
}

@LazySingleton(as: StorageRemoteDataSource)
class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final FirebaseStorage _storage;

  StorageRemoteDataSourceImpl(this._storage);

  @override
  Future<String> uploadReceiptImage({required String ticketId, required File imageFile}) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      // Menyusun struktur path penyimpanan yang rapi di Firebase Storage
      final Reference ref = _storage.ref().child('receipts').child(ticketId).child('REF-$timestamp.jpg');
      
      // Proses unggah berkas dengan metadata content type yang jelas
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal mengunggah gambar ke Storage: $e');
    }
  }
}