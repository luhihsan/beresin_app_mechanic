// lib/data/datasources/storage_remote_datasource.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
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
  static const String _imgBbUrl = 'https://api.imgbb.com/1/upload';

  /// Helper internal untuk membaca API Key dari berkas secrets.json secara aman
  Future<String> _loadApiKeyFromSecrets() async {
    try {
      final String response = await rootBundle.loadString('secrets.json');
      final Map<String, dynamic> data = jsonDecode(response);
      final String? apiKey = data['IMGBB_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty || apiKey.contains('masukkan_api_key')) {
        throw Exception('API Key ImgBB di dalam secrets.json belum diisi dengan benar.');
      }
      return apiKey;
    } catch (e) {
      throw Exception('Gagal membaca file secrets.json. Pastikan berkas sudah didaftarkan di pubspec.yaml: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadReceiptImage({
    required String ticketId,
    required File imageFile,
  }) async {
    try {
      // 1. Ambil token API Key ImgBB secara dinamis dari secrets.json
      final String activeApiKey = await _loadApiKeyFromSecrets();

      // 2. Susun payload MultiPart HTTP Request
      final request = http.MultipartRequest('POST', Uri.parse(_imgBbUrl))
        ..fields['key'] = activeApiKey
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // 3. Tembak ke server hosting ImgBB
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String uploadedUrl = responseData['data']['url'];
        return uploadedUrl;
      } else {
        throw Exception('Server ImgBB menolak unggahan nota. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kendala enkripsi/jaringan pada upload nota ImgBB: ${e.toString()}');
    }
  }
}