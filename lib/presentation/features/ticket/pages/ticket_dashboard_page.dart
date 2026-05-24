// lib/presentation/features/ticket/pages/ticket_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: const Text(
            'ANTREAN SERVIS REALTIME',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueGrey.shade900,
          elevation: 0,
          centerTitle: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const Badge(
                alignment: AlignmentDirectional.topEnd,
                child: Icon(Icons.notifications_none_rounded, color: Colors.black87),
              ),
            )
          ],
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TicketError) {
              return Center(
                child: Text('Gagal memuat data: ${state.message}', style: const TextStyle(color: Colors.red)),
              );
            }

            if (state is TicketLoaded) {
              // Menyaring tiket yang aktif saja untuk halaman dashboard mekanik
              final activeTickets = state.tickets.where((t) => t.status != 'completed').toList();

              if (activeTickets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.blueGrey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Semua Tugas Selesai!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: activeTickets.length,
                itemBuilder: (context, index) {
                  return _ModernTicketCard(ticket: activeTickets[index]);
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

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blueGrey.shade200),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor, width: 6)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.ticketId,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade500, fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ticket.status == 'processing' ? 'SEDANG DIKERJAKAN' : 'MENUNGGU',
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Deskripsi Perbaikan:',
                style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade400, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                ticket.tasks,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed_rounded, size: 16, color: Colors.blueGrey.shade400),
                      const SizedBox(width: 4),
                      Text('KM Masuk: ${ticket.kmCheckIn}', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_rounded, color: Colors.blueGrey.shade400, size: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}