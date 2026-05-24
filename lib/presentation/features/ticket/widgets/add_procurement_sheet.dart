// lib/presentation/features/ticket/widgets/add_procurement_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProcurementSheet extends StatefulWidget {
  final Function(String partName, String supplierStore, int cost, String receiptUrl) onSubmit;

  const AddProcurementSheet({super.key, required this.onSubmit});

  @override
  State<AddProcurementSheet> createState() => _AddProcurementSheetState();
}

class _AddProcurementSheetState extends State<AddProcurementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _partNameController = TextEditingController();
  final _storeController = TextEditingController();
  final _costController = TextEditingController();
  
  // Placeholder URL foto nota fisik sebelum integrasi Firebase Storage penuh
  final String _mockReceiptUrl = 'https://firebasestorage.googleapis.com/v0/b/mock-receipt.jpg';

  @override
  void dispose() {
    _partNameController.dispose();
    _storeController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _handleSubmitting() {
    if (_formKey.currentState!.validate()) {
      // Mengonversi input teks string menjadi Integer murni (Anti-Floating Point Error)
      final int parsedCost = int.parse(_costController.text.replaceAll('.', ''));
      
      widget.onSubmit(
        _partNameController.text.trim(),
        _storeController.text.trim(),
        parsedCost,
        _mockReceiptUrl,
      );
      
      Navigator.pop(context); // Tutup lembar bottom sheet setelah sukses
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      // Mengatur posisi sheet agar otomatis naik saat keyboard HP mekanik muncul
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
              // Top Indicator Bar Drag Icon
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(color: Colors.blueGrey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'INPUT NOTA REIMBURSEMENT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A), letterSpacing: 0.5),
              ),
              const Text(
                'Pastikan data toko dan nominal sesuai dengan nota fisik asli.',
                style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              // Input Nama Suku Cadang / Oli
              TextFormField(
                controller: _partNameController,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Nama Barang / Suku Cadang',
                  prefixIcon: const Icon(Icons.precision_manufacturing_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama barang wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Input Nama Toko / Supplier Luar
              TextFormField(
                controller: _storeController,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Toko Supplier / Bengkel Luar',
                  prefixIcon: const Icon(Icons.storefront_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama toko wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Input Harga Modal Barang (Integer Validated)
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSubmitting(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E40AF)),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Menolak karakter selain angka desimal murni
                ],
                decoration: InputDecoration(
                  labelText: 'Harga Beli Modal (Total)',
                  prefixIcon: const Icon(Icons.payments_rounded),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nominal harga wajib diisi';
                  if (int.tryParse(value) == null) return 'Format angka tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Simulasi Input Dokumen Foto Nota Fisik
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueGrey.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Foto Nota Fisik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Nota Otomatis Tersimpan Aman (.jpg)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Submit Form Pengadaan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmitting,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('SIMPAN NOTA PENGADAAN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}