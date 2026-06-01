// lib/presentation/features/ticket/pages/ticket_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/add_procurement_sheet.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/image_preview_dialog.dart';
import 'package:mechanic_app/presentation/features/ticket/widgets/service_completion_dialog.dart';

class TicketDetailPage extends StatelessWidget {
  final String ticketDocumentId;

  const TicketDetailPage({super.key, required this.ticketDocumentId});

  // Fungsi pembantu untuk mengamankan link gambar dari pemblokiran SSL ISP lokal
  String _getSafeImageUrl(String url) {
    return url.replaceAll('i.ibb.co', 'i.ibb.co.com');
  }

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
      body: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state is TicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red.shade800, behavior: SnackBarBehavior.floating),
            );
          }
        },
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          List<ServiceTicketEntity> currentTickets = [];
          if (state is TicketLoaded) {
            currentTickets = state.tickets;
          }

          if (currentTickets.isEmpty) {
            return const Center(child: Text('Memuat Dokumen Antrean...'));
          }

          final ticket = currentTickets.firstWhere(
            (element) => element.id == ticketDocumentId, 
            orElse: () => currentTickets.first,
          );
          
          final int totalBelanja = ticket.externalProcurements.fold(0, (sum, item) => sum + item.cost);
          final isWaiting = ticket.status == 'waiting';
          final isProcessing = ticket.status == 'processing';
          final List<String> complaintPhotos = ticket.complaintPhotoUrls;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.blueGrey.shade900, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${ticket.carDetails.brand} ${ticket.carDetails.type} (${ticket.carDetails.year})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                            const SizedBox(height: 4),
                            Text('No. Polisi: ${ticket.carDetails.plate}  |  Warna: ${ticket.carDetails.color}', style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12, fontWeight: FontWeight.w500)),
                            Text('Mesin: ${ticket.carDetails.engineType}  |  Transmisi: ${ticket.carDetails.transmission}', style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text('KM AWAL CHECK-IN BENGKEL: ${ticket.kmCheckIn} KM', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text('DOKUMENTASI FOTO KERUSAKAN (DARI PELANGGAN):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      if (complaintPhotos.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blueGrey.shade100)),
                          child: const Text('Pelanggan tidak melampirkan foto keluhan fisik.', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                        )
                      else
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: complaintPhotos.length,
                            itemBuilder: (context, idx) {
                              final safeUrl = _getSafeImageUrl(complaintPhotos[idx]);
                              return GestureDetector(
                                onTap: () => showDialog(context: context, builder: (_) => ImagePreviewDialog(imageUrl: safeUrl)),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 140,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blueGrey.shade100)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    safeUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey)),
                                    loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueGrey.shade100)),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text('PENGADAAN REIMBURSEMENT SPAREPART & NOTA LUAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5), maxLines: 2)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                            child: Text('${ticket.externalProcurements.length} Nota', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (ticket.externalProcurements.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueGrey.shade100)),
                          child: const Column(
                            children: [
                              Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey),
                              SizedBox(height: 12),
                              Text('Belum ada pengadaan nota luar yang diinput oleh mekanik', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.center),
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
                            final hasInvoicePhoto = item.receiptPhotoUrl.isNotEmpty && item.receiptPhotoUrl.startsWith('http');
                            final safeReceiptUrl = _getSafeImageUrl(item.receiptPhotoUrl);

                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.blueGrey.shade100)),
                              child: ExpansionTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.green),
                                ),
                                title: Text(item.partName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey.shade900)),
                                subtitle: Text('Toko/Supplier: ${item.supplierStore}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                trailing: Text(currencyFormatter.format(item.cost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        const SizedBox(height: 4),
                                        const Text('LAMPIRAN FOTO NOTA FISIK / KWITANSI REIMBURSE (KLIK UNTUK FULL):', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                        const SizedBox(height: 8),
                                        if (hasInvoicePhoto)
                                          GestureDetector(
                                            onTap: () => showDialog(context: context, builder: (_) => ImagePreviewDialog(imageUrl: safeReceiptUrl)),
                                            child: Container(
                                              width: double.infinity, height: 200,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                safeReceiptUrl, fit: BoxFit.cover,
                                                loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
                                                errorBuilder: (context, err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.red)),
                                              ),
                                            ),
                                          )
                                        else
                                          const Text('Mekanik tidak menyertakan foto lampiran nota belanja.', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.red)),
                                      ],
                                    ),
                                  )
                                ],
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
                              const Text('TOTAL BIAYA PENGADAAN (REIMBURSE):', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                              Text(currencyFormatter.format(totalBelanja), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isProcessing) ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _openAddProcurementForm(context, context.read<TicketCubit>(), ticket),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue.shade900,
                              side: BorderSide(color: Colors.blue.shade300, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.receipt_long_rounded),
                            label: const Text('TAMBAH NOTA REIMBURSEMENT SPAREPART', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final cubit = context.read<TicketCubit>();
                            if (isWaiting) {
                              cubit.updateStatus(ticketDocId: ticketDocumentId, newStatus: 'processing');
                            } else if (isProcessing) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogCtx) => ServiceCompletionDialog(
                                  totalBelanja: totalBelanja,
                                  onConfirm: (kmService, mechanicNotes, proofImage) {
                                    // REKTIFIKASI ERROR: Menggunakan nama parameter 'ticketId' yang benar sesuai kontrak di Cubit kamu
                                    context.read<TicketCubit>().completeService(
                                      ticketDocId: ticketDocumentId,
                                      ticketId: ticket.ticketId, 
                                      kmService: kmService,
                                      invoiceAmount: totalBelanja,
                                      mechanicNotes: mechanicNotes,
                                      proofImage: proofImage,
                                    );
                                    Navigator.pop(dialogCtx);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isWaiting ? Colors.amber.shade800 : Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            isWaiting ? 'MULAI PROSES KERJA' : isProcessing ? 'SELESAIKAN PERBAIKAN' : 'SERVIS SELESAI',
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
        },
      ),
    );
  }
}