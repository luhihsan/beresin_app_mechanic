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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('DETAIL PENGERJAAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            // Mencari dokumen spesifik dari local stream state yang paling mutakhir
            final ticket = state.tickets.firstWhere((element) => element.id == ticketDocumentId);
            
            // Kalkulasi akumulasi total modal belanja mekanik saat ini
            final int totalBelanja = ticket.externalProcurements.fold(0, (sum, item) => sum + item.cost);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Atas: Informasi Utama Identitas Penugasan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.ticketId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)),
                        const SizedBox(height: 8),
                        const Text('DESKRIPSI TUGAS PERBAIKAN:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(ticket.tasks, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Header: Daftar Pembelian Suku Cadang Luar (Reimbursement)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PENGADAAN SUKU CADANG LUAR',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 0.5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                        child: Text('${ticket.externalProcurements.length} Barang', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // List Item Belanjaan Mekanik (Jika Kosong Tampilkan Layout Hiasan)
                  if (ticket.externalProcurements.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_rounded, size: 48, color: Colors.blueGrey.shade300),
                          const SizedBox(height: 12),
                          const Text('Belum ada Suku Cadang yang diinput', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ticket.externalProcurements.length,
                      itemBuilder: (context, index) {
                        final procurement = ticket.externalProcurements[index];
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.shopping_bag_rounded, color: Colors.green),
                            ),
                            title: Text(procurement.partName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Toko: ${procurement.supplierStore}', style: const TextStyle(fontSize: 12)),
                            trailing: Text(
                              currencyFormatter.format(procurement.cost),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // Card Akumulasi Pengeluaran Ringkasan Biaya Belanjaan
                  if (ticket.externalProcurements.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A), // Premium Dark Card
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL MODAL NOTA BERSAMA:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                          Text(currencyFormatter.format(totalBelanja), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 100), // Memberi ruang jeda di bagian bawah layar
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      // Floating Action Button (FAB) berukuran mantap untuk memicu form Bottom Sheet
      floatingActionButton: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            final currentCubit = context.read<TicketCubit>();
            return FloatingActionButton.extended(
              onPressed: () => _openAddProcurementForm(context, currentCubit),
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('INPUT NOTA BELANJA', style: TextStyle(fontWeight: FontWeight.bold)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}