import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

abstract class StorageRemoteDataSource {
  /// Mengunggah berkas foto nota ke dalam Firebase Storage.
  /// Mengembalikan tautan unduhan (Download URL) digital berupa [String].
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
      
      // Menyusun struktur direktori penyimpanan yang rapi: receipts/TKT-ID/REF-timestamp.jpg
      final Reference ref = _storage.ref().child('receipts').child(ticketId).child('REF-$timestamp.jpg');
      
      // Proses eksekusi unggah berkas dengan penambahan metadata gambar
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal mengunggah berkas gambar ke Firebase Storage: $e');
    }
  }
}