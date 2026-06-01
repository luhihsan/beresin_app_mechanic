// lib/presentation/features/ticket/widgets/service_completion_dialog.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ServiceCompletionDialog extends StatefulWidget {
  final int totalBelanja;
  final Function(int kmService, String mechanicNotes, File? proofImage) onConfirm;

  const ServiceCompletionDialog({
    super.key,
    required this.totalBelanja,
    required this.onConfirm,
  });

  @override
  State<ServiceCompletionDialog> createState() => _ServiceCompletionDialogState();
}

class _ServiceCompletionDialogState extends State<ServiceCompletionDialog> {
  final _odometerController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _proofImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() {
          _proofImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil foto bukti: $e");
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Ambil Foto via Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String totalBelanjaFormatted = widget.totalBelanja.toString().replaceAllMapped(
        RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.");

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 26),
          const SizedBox(width: 10),
          const Text(
            'KONFIRMASI SELESAI SERVIS',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Tagihan Otomatis (Dari Nota Belanja):', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text(
                      'Rp $totalBelanjaFormatted',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green.shade900),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _odometerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Odometer Selesai (KM)',
                  hintText: 'Masukkan angka KM aktual mobil',
                  prefixIcon: const Icon(Icons.speed_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Odometer akhir wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Catatan Perbaikan (Untuk Pelanggan)',
                  hintText: 'Misal: Jangan di geber-geber, oli baru...',
                  prefixIcon: const Icon(Icons.rate_review_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FOTO BUKTI PENGERJAAN SELESAI (DASHBOARD/MESIN):',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _proofImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_proofImage!, fit: BoxFit.cover),
                            Container(color: Colors.black12),
                            const Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                              ),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_rounded, size: 28, color: Colors.blueGrey.shade400),
                            const SizedBox(height: 6),
                            const Text('Ambil / Unggah Foto Bukti', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('BATAL', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(
                int.parse(_odometerController.text),
                _notesController.text.trim(),
                _proofImage,
              );
            }
          },
          child: const Text('SUBMIT & SELESAI', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}