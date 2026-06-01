// lib/presentation/features/ticket/pages/ticket_history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_app/core/di/injection.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/pages/ticket_detail_page.dart';

class TicketHistoryPage extends StatelessWidget {
  final String mechanicId;

  const TicketHistoryPage({super.key, required this.mechanicId});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return BlocProvider<TicketCubit>(
      create: (context) => getIt<TicketCubit>()..watchMechanicTickets(mechanicId),
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BERESIN GARASI',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.blue, letterSpacing: 1.0),
              ),
              Text(
                'Riwayat Servis Selesai',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.sync_rounded, color: Colors.black87),
                  onPressed: () => context.read<TicketCubit>().watchMechanicTickets(mechanicId),
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            }

            if (state is TicketError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Gangguan sistem: ${state.message}', style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
              );
            }

            if (state is TicketLoaded) {
              // FILTER GUARDIAN: Di halaman riwayat, hanya menampilkan tiket yang sudah 'completed'
              final completedTickets = state.tickets.where((t) => t.status == 'completed').toList();

              // SORTING IMPLEMENTATION: Mengurutkan dari tiket selesai yang paling terbaru di atas
              completedTickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              if (completedTickets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 64, color: Colors.blueGrey.shade300),
                        const SizedBox(height: 16),
                        const Text('Belum Ada Riwayat Selesai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(height: 4),
                        const Text('Tiket servis yang telah Anda selesaikan akan muncul di sini.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: completedTickets.length,
                itemBuilder: (context, index) {
                  return _HistoryTicketCard(ticket: completedTickets[index], currencyFormatter: currencyFormatter);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _HistoryTicketCard extends StatelessWidget {
  final ServiceTicketEntity ticket;
  final NumberFormat currencyFormatter;

  const _HistoryTicketCard({required this.ticket, required this.currencyFormatter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            final currentTicketCubit = context.read<TicketCubit>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<TicketCubit>.value(
                  value: currentTicketCubit,
                  child: TicketDetailPage(ticketDocumentId: ticket.id),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 5, color: Colors.green.shade700),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(ticket.ticketId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'SELESAI',
                            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_car_filled_rounded, color: Colors.blueGrey, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ticket.carDetails.brand} ${ticket.carDetails.type}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                ),
                                Text(
                                  'No. Polisi: ${ticket.carDetails.plate} | ${ticket.carDetails.color}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    
                    const Text('TUGAS PERBAIKAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(ticket.tasks, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Colors.black12, height: 1),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.speed_rounded, size: 18, color: Colors.blueGrey),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Odometer Aktual', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text('${ticket.kmService} KM', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total Tagihan', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text(
                              currencyFormatter.format(ticket.invoiceAmount),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}