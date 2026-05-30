// lib/data/datasources/storage_remote_datasource.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class StorageRemoteDataSource {
  Future<String> uploadReceiptImage({
    required String ticketId,
    required File imageFile,
  });
}

@LazySingleton(as: StorageRemoteDataSource)
class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  // SINKRONISASI KEAMANAN: Membaca token langsung dari compile-time environment
  final String _imgBbApiKey = const String.fromEnvironment('IMGBB_API_KEY');
  static const String _imgBbUrl = 'https://api.imgbb.com/1/upload';

  @override
  Future<String> uploadReceiptImage({
    required String ticketId,
    required File imageFile,
  }) async {
    if (_imgBbApiKey.isEmpty) {
      throw Exception('Konfigurasi Gagal: API Key ImgBB belum disuntikkan ke Mechanic App!');
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_imgBbUrl))
        ..fields['key'] = _imgBbApiKey
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['data']['url'] as String; // Mengembalikan URL string publik
      } else {
        throw Exception('Server ImgBB menolak unggahan nota. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kendala jaringan pada upload nota ImgBB: ${e.toString()}');
    }
  }
}