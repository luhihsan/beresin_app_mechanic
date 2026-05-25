import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanic_app/core/constants/asset_paths.dart'; // Solusi: Penambahan import AssetPaths secara presisi
import 'package:mechanic_app/core/di/injection.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';
import 'package:mechanic_app/presentation/features/ticket/pages/ticket_detail_page.dart'; // Import halaman detail

class TicketDashboardPage extends StatelessWidget {
  final String mechanicId;

  const TicketDashboardPage({super.key, required this.mechanicId});

  @override
  Widget build(BuildContext context) {
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
                'Antrean Kerja Realtime',
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
              child: IconButton(
                icon: const Icon(Icons.sync_rounded, color: Colors.black87),
                onPressed: () => context.read<TicketCubit>().watchMechanicTickets(mechanicId),
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
              final activeTickets = state.tickets.where((t) => t.status != 'completed').toList();

              if (activeTickets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                          child: Image.asset(
                            AssetPaths.icCalendar, // Berhasil membaca indeks file berkat import lengkap
                            height: 56,
                            width: 56,
                            color: Colors.blue,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.assignment_turned_in_rounded, size: 56, color: Colors.blue);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Semua Antrean Bersih!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 6),
                        const Text('Belum ada penugasan masuk dari dashboard owner.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: activeTickets.length,
                itemBuilder: (context, index) {
                  return _ModernTicketCard(ticket: activeTickets[index]); // Sinkron: menggunakan _ModernTicketCard
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

class _ModernTicketCard extends StatelessWidget {
  final ServiceTicketEntity ticket;

  const _ModernTicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isProcessing = ticket.status == 'processing';
    final accentColor = isProcessing ? Colors.blue.shade700 : Colors.orange.shade800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.04), // Perbaikan: menggunakan opsitas aman beralaskan material blueGrey
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
              Container(height: 5, color: accentColor),
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
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            isProcessing ? 'DIKERJAKAN' : 'ANTREAN',
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    
                    const Text('TUGAS PERBAIKAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(ticket.tasks, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
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
                                const Text('KM CHECK-IN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text('${ticket.kmCheckIn} KM', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accentColor),
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