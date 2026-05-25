// lib/presentation/features/ticket/widgets/add_procurement_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // Pustaka pengelola kamera native

/// Widget [AddProcurementSheet] menyediakan antarmuka lembar bawah (bottom sheet)
/// utilitarian untuk menginput data pengadaan suku cadang luar oleh mekanik.
class AddProcurementSheet extends StatefulWidget {
  // PEMBARUAN: Mengubah parameter ke-4 dari String URL menjadi berkas File fisik objek
  final Function(String partName, String supplierStore, int cost, File? imageFile) onSubmit;

  const AddProcurementSheet({super.key, required this.onSubmit});

  @override
  State<AddProcurementSheet> createState() => _AddProcurementSheetState();
}

class _AddProcurementSheetState extends State<AddProcurementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _partNameController = TextEditingController();
  final _storeController = TextEditingController();
  final _costController = TextEditingController();
  
  // Variabel status internal untuk menyimpan berkas foto nota fisik
  File? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _partNameController.dispose();
    _storeController.dispose();
    _costController.dispose();
    super.dispose();
  }

  /// Membuka kamera perangkat secara native untuk mengambil gambar nota fisik luar.
  Future<void> _takeReceiptPhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Kompresi kualitas gambar hingga 70% demi efisiensi RAM & Storage
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengakses kamera perangkat: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _handleSubmitting() {
    if (_formKey.currentState!.validate()) {
      // GOLDEN RULE: Menghapus seluruh karakter non-digit dan melakukan parsing ke Integer murni
      final int parsedCost = int.parse(_costController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      
      widget.onSubmit(
        _partNameController.text.trim(),
        _storeController.text.trim(),
        parsedCost,
        _capturedImage, // Mengirimkan objek berkas foto asli hasil jepretan kamera
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Mengatur inset bottom secara dinamis mengikuti visibilitas keyboard perangkat mekanik
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade300, 
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'INPUT NOTA PENGADAAN BARANG',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A), letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mekanik wajib menginput data harga modal asli sesuai dengan bukti nota fisik toko.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              // Bidang Input Nama Suku Cadang / Oli
              TextFormField(
                controller: _partNameController,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Nama Suku Cadang / Oli',
                  prefixIcon: const Icon(Icons.precision_manufacturing_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama barang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Bidang Input Toko Pembelian
              TextFormField(
                controller: _storeController,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Nama Toko / Supplier Luar',
                  prefixIcon: const Icon(Icons.storefront_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama toko tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Bidang Input Harga Beli (Hanya menerima Angka)
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSubmitting(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E40AF)),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Proteksi dari input karakter teks luar
                ],
                decoration: InputDecoration(
                  labelText: 'Harga Beli Modal (Total)',
                  prefixIcon: const Icon(Icons.payments_rounded),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nominal pengeluaran wajib diisi';
                  if (int.tryParse(value) == null) return 'Format angka numerik tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // PEMBARUAN: Komponen Bukti Foto Fisik Interaktif Aktif Kamera
              InkWell(
                onTap: _takeReceiptPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _capturedImage != null ? Colors.green.shade300 : const Color(0xFFE2E8F0),
                      width: _capturedImage != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _capturedImage != null ? Icons.photo_library_rounded : Icons.camera_alt_rounded, 
                        color: _capturedImage != null ? Colors.green : const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _capturedImage != null ? 'Foto Nota Terekam' : 'Ambil Foto Nota Fisik', 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              _capturedImage != null 
                                  ? 'Ketuk kembali untuk mengulang jepretan' 
                                  : 'Wajib melampirkan foto nota sebagai bukti otentik', 
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      if (_capturedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            _capturedImage!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Aksi Penyimpanan Dokumen Belanja
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmitting,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('SIMPAN DATA PENGADAAN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}