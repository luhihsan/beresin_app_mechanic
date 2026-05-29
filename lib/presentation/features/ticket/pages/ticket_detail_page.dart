// lib/presentation/features/ticket/pages/ticket_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/add_procurement_sheet.dart';

class TicketDetailPage extends StatelessWidget {
  final String ticketDocumentId;

  const TicketDetailPage({super.key, required this.ticketDocumentId});

  void _openAddProcurementForm(BuildContext context, TicketCubit cubit, ServiceTicketEntity ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return AddProcurementSheet(
          onSubmit: (partName, supplierStore, cost, imageFile) {
            cubit.submitExternalProcurement(
              ticketDocId: ticketDocumentId,
              ticketId: ticket.ticketId,
              partName: partName,
              supplierStore: supplierStore,
              cost: cost,
              imageFile: imageFile,
            );
          },
        );
      },
    );
  }

  // BARU: Protokol Dialog Penutupan Validasi Tugas (Langkah C)
  void _showCompletionDialog(BuildContext context, TicketCubit cubit, String docId) {
    final odometerController = TextEditingController();
    final invoiceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('INPUT REALISASI KERJA BENGKEL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: odometerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Odometer Selesai (KM)',
                    hintText: 'Masukkan angka KM aktual mobil',
                    prefixIcon: Icon(Icons.speed_rounded, size: 20),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Odometer akhir wajib diisi' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: invoiceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Tagihan Jasa & Sparepart (Rp)',
                    hintText: 'Contoh: 350000',
                    prefixIcon: Icon(Icons.payments_rounded, size: 20),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Nominal tagihan riil wajib diisi' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BATAL', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Memicu fungsi update penutupan tugas terintegrasi ke Cubit
                  cubit.completeService(
                    ticketDocId: docId,
                    kmService: int.parse(odometerController.text),
                    invoiceAmount: int.parse(invoiceController.text),
                  );
                  Navigator.pop(context); // Tutup dialog modal
                  Navigator.pop(context); // Otomatis kembali ke antrean dashboard utama
                }
              },
              child: const Text('SUBMIT DATA & SELESAI'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('RINCIAN TUGAS AKTIF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            final ticket = state.tickets.firstWhere(
              (element) => element.id == ticketDocumentId, 
              orElse: () => state.tickets.first,
            );
            
            final int totalBelanja = ticket.externalProcurements.fold(0, (sum, item) => sum + item.cost);
            final isWaiting = ticket.status == 'waiting';
            final isProcessing = ticket.status == 'processing';

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX ERROR: Mengubah akses Bracket [] ke Dot (.) untuk Spesifikasi Kendaraan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ticket.carDetails.brand} ${ticket.carDetails.type} (${ticket.carDetails.year})',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No. Polisi: ${ticket.carDetails.plate}  |  Warna: ${ticket.carDetails.color}',
                                style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Mesin: ${ticket.carDetails.engineType}  |  Transmisi: ${ticket.carDetails.transmission}',
                                style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'KM AWAL CHECK-IN BENKEL: ${ticket.kmCheckIn} KM',
                                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // BARU: Komponen Slider Gambar Keluhan Fisik Kendaraan (Langkah B)
                        if (ticket.complaintPhotoUrls.isNotEmpty) ...[
                          const Text('DOKUMENTASI FOTO KERUSAKAN AWAL Casier:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ticket.complaintPhotoUrls.length,
                              itemBuilder: (context, idx) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blueGrey.shade100),
                                    image: DecorationImage(
                                      image: NetworkImage(ticket.complaintPhotoUrls[idx]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Card: Deskripsi Tugas Keluhan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blueGrey.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ticket.ticketId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13, letterSpacing: 0.5)),
                              const SizedBox(height: 12),
                              const Text('DESKRIPSI KELUHAN & PERBAIKAN:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(ticket.tasks, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Header Pengadaan Suku Cadang Luar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'PENGADAAN REIMBURSEMENT',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                              child: Text('${ticket.externalProcurements.length} Terinput', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // List Item Nota Pembelian
                        if (ticket.externalProcurements.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueGrey.shade100)),
                            child: const Column(
                              children: [
                                Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('Belum ada nota luar yang diinput', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ticket.externalProcurements.length,
                            itemBuilder: (context, index) {
                              final item = ticket.externalProcurements[index];
                              return Card(
                                color: Colors.white,
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.blueGrey.shade100)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.green),
                                  ),
                                  title: Text(item.partName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey.shade900)),
                                  subtitle: Text('Toko: ${item.supplierStore}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  trailing: Text(
                                    currencyFormatter.format(item.cost),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 24),

                        if (ticket.externalProcurements.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.blueGrey.shade900, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('TOTAL BELANJA NOTA:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                                Text(currencyFormatter.format(totalBelanja), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // PANEL UTAMA BAWAH: Tombol Aksi Kerja
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        if (isProcessing) ...[
                          ElevatedButton(
                            onPressed: () => _openAddProcurementForm(context, context.read<TicketCubit>(), ticket),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade50,
                              foregroundColor: Colors.blue.shade900,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Icon(Icons.add_photo_alternate_rounded),
                          ),
                          const SizedBox(width: 12),
                        ],
                        
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final cubit = context.read<TicketCubit>();
                              if (isWaiting) {
                                cubit.updateStatus(ticketDocId: ticketDocumentId, newStatus: 'processing');
                              } else if (isProcessing) {
                                // SINKRONISASI INTEGRASI: Mengaktifkan Dialog Pop-up Form Pengisian Odometer & Invoice Jasa
                                _showCompletionDialog(context, cubit, ticketDocumentId);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isWaiting ? Colors.amber.shade800 : Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text(
                              isWaiting 
                                  ? 'MULAI PROSES KERJA' 
                                  : isProcessing ? 'SELESAIKAN PERBAIKAN' : 'SERVIS SELESAI',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}