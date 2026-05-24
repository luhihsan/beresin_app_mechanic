// lib/presentation/features/ticket/pages/ticket_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanic_app/core/constants/asset_paths.dart'; // Solusi: Menyematkan import file AssetPaths
import 'package:mechanic_app/core/di/injection.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';

class TicketDashboardPage extends StatelessWidget {
  final String mechanicId;

  const TicketDashboardPage({super.key, required this.mechanicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketCubit>(
      create: (context) => getIt<TicketCubit>()..watchMechanicTickets(mechanicId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BERESIN GARASI',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3B82F6), letterSpacing: 1.0),
              ),
              Text(
                'Antrean Kerja Realtime',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
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
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.sync_rounded, color: Color(0xFF475569)),
                onPressed: () => context.read<TicketCubit>().watchMechanicTickets(mechanicId),
              ),
            )
          ],
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1E40AF)));
            }

            if (state is TicketError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626)),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Gangguan sistem: ${state.message}', style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w600))),
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
                          decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                          child: Image.asset(
                            AssetPaths.icCalendar, // Solusi: Berhasil mengenali AssetPaths setelah di-import
                            height: 56,
                            width: 56,
                            color: const Color(0xFF3B82F6),
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.assignment_turned_in_rounded, size: 56, color: Color(0xFF3B82F6));
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Semua Antrean Bersih!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 6),
                        const Text('Belum ada penugasan masuk dari dashboard owner.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: activeTickets.length,
                itemBuilder: (context, index) {
                  return _PremiumTicketCard(ticket: activeTickets[index]);
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

class _PremiumTicketCard extends StatelessWidget {
  final ServiceTicketEntity ticket;

  const _PremiumTicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isProcessing = ticket.status == 'processing';
    final accentColor = isProcessing ? const Color(0xFF2563EB) : const Color(0xFFD97706);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // Solusi: Mengganti .withOpacity dengan .withValues
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Membuka formulir pengerjaan: ${ticket.ticketId}')),
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
                            const Icon(Icons.confirmation_number_outlined, size: 16, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 6),
                            Text(ticket.ticketId, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 13)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            // Solusi: Mengganti .withOpacity dengan .withValues
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            isProcessing ? 'DIKERJAKAN' : 'ANTREAN',
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    
                    const Text('TUGAS PERBAIKAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(ticket.tasks, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.speed_rounded, size: 18, color: Color(0xFF475569)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('KM CHECK-IN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                                Text('${ticket.kmCheckIn} KM', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
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