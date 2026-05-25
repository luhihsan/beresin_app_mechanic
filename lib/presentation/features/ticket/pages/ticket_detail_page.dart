// lib/presentation/features/ticket/pages/ticket_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/add_procurement_sheet.dart';

class TicketDetailPage extends StatelessWidget {
  final String ticketDocumentId;

  const TicketDetailPage({super.key, required this.ticketDocumentId});

  void _openAddProcurementForm(BuildContext context, TicketCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return AddProcurementSheet(
          onSubmit: (partName, supplierStore, cost, receiptUrl) {
            cubit.submitExternalProcurement(
              ticketDocId: ticketDocumentId,
              partName: partName,
              supplierStore: supplierStore,
              cost: cost,
              receiptPhotoUrl: receiptUrl,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50, // Menggunakan blueGrey standar material
      appBar: AppBar(
        title: const Text('RINCIAN TUGAS AKTIF', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            // Mencari data tiket spesifik dari local stream snapshot
            final ticket = state.tickets.firstWhere((element) => element.id == ticketDocumentId, 
              orElse: () => state.tickets.first // Safety fallback jika rute transisi sangat cepat
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
                        // Card Atas: Deskripsi Tugas Keluhan
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
                                const SizedBox(height: 12),
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
                
                // PANEL UTAMA BAWAH: Tombol Taktis Aksi Status Kerja Mekanik
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
                        // Tombol Input Nota (Hanya aktif jika status pengerjaan sudah dimulai)
                        if (isProcessing) ...[
                          ElevatedButton(
                            onPressed: () => _openAddProcurementForm(context, context.read<TicketCubit>()),
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
                        
                        // Tombol Utama Alur Kerja
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final cubit = context.read<TicketCubit>();
                              if (isWaiting) {
                                cubit.updateStatus(ticketDocId: ticketDocumentId, newStatus: 'processing');
                              } else if (isProcessing) {
                                cubit.updateStatus(ticketDocId: ticketDocumentId, newStatus: 'completed');
                                Navigator.pop(context); // Tutup halaman dan kembali ke antrean utama jika selesai
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
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
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