// lib/presentation/features/ticket/pages/ticket_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/add_procurement_sheet.dart';

/// Halaman [TicketDetailPage] menampilkan rincian penugasan servis aktif
/// beserta log pengadaan suku cadang luar secara terpadu.
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
        title: const Text('RINCIAN TUGAS AKTIF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            // Mencari entitas dokumen yang cocok dari daftar stream realtime lokal
            final ticket = state.tickets.firstWhere((element) => element.id == ticketDocumentId);
            
            // Mengalkulasi akumulasi biaya modal pengadaan suku cadang luar
            final int totalBelanja = ticket.externalProcurements.fold(0, (sum, item) => sum + item.cost);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Komponen Informasi Ringkasan Tiket Servis
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
                        Text(ticket.ticketId, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3B82F6), fontSize: 13, letterSpacing: 0.5)),
                        const SizedBox(height: 12),
                        const Text('DESKRIPSI KELUHAN & PERBAIKAN:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(ticket.tasks, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Header List Komponen Suku Cadang Luar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PENGADAAN REIMBURSEMENT',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569), letterSpacing: 0.5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                        child: Text('${ticket.externalProcurements.length} Terinput', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Daftar Komponen Belanja Suku Cadang Mekanik
                  if (ticket.externalProcurements.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(16), 
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_rounded, size: 48, color: Colors.blueGrey.shade300),
                          const SizedBox(height: 12),
                          const Text('Belum ada nota luar yang diinput', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFF1F5F9))),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF10B981)),
                            ),
                            title: Text(item.partName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                            subtitle: Text('Toko: ${item.supplierStore}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            trailing: Text(
                              currencyFormatter.format(item.cost),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // Ringkasan Akumulasi Total Biaya Pengadaan Nota Fisik
                  if (ticket.externalProcurements.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL BELANJA NOTA:', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                          Text(currencyFormatter.format(totalBelanja), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1E40AF)));
        },
      ),
      // Tombol Mengambang (FAB) untuk Memanggil Bottom Sheet Formulir Pengadaan
      floatingActionButton: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoaded) {
            final ticketCubit = context.read<TicketCubit>();
            return FloatingActionButton.extended(
              onPressed: () => _openAddProcurementForm(context, ticketCubit),
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('INPUT NOTA BELANJA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 13)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}