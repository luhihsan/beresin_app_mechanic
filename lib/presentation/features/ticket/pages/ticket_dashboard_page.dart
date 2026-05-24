// lib/presentation/features/ticket/pages/ticket_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanic_app/core/di/injection.dart';
import 'package:mechanic_app/domain/entities/service_ticket_entity.dart';
import 'package:mechanic_app/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_cubit.dart';
import 'package:mechanic_app/presentation/features/ticket/cubit/ticket_state.dart';

class TicketDashboardPage extends StatelessWidget {
  final String mechanicId;

  const TicketDashboardPage({super.key, required this.mechanicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketCubit>(
      // Memicu stream realtime Firestore tepat saat halaman dashboard di-mount
      create: (context) => getIt<TicketCubit>()..watchMechanicTickets(mechanicId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TUGAS MEKANIK',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Keluar Aplikasi',
              onPressed: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TicketError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            if (state is TicketLoaded) {
              final tickets = state.tickets;

              if (tickets.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada tiket servis\nyang ditugaskan ke Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return _TicketCard(ticket: ticket);
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

class _TicketCard extends StatelessWidget {
  final ServiceTicketEntity ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Penentuan warna badge berdasarkan status order
    Color statusColor;
    String statusText;

    switch (ticket.status) {
      case 'waiting':
        statusColor = Colors.orange.shade800;
        statusText = 'MENUNGGU';
        break;
      case 'processing':
        statusColor = Colors.blue.shade800;
        statusText = 'DIPROSES';
        break;
      case 'completed':
        statusColor = Colors.green.shade800;
        statusText = 'SELESAI';
        break;
      default:
        statusColor = Colors.grey;
        statusText = ticket.status.toUpperCase();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigasi ke Halaman Detail Servis & Input Nota Pengadaan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka tiket: ${ticket.ticketId}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Atas: ID Tiket & Badge Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.ticketId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Detail Kendaraan & Informasi Tugas
              Row(
                children: [
                  const Icon(Icons.directions_car_filled_rounded, size: 40, color: Colors.blueGrey),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PLAT NOMOR:',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // Simulasi data kendaraan dari ID / relasi jika diperlukan,
                          // untuk sementara kita tampilkan info core task-nya
                          'Task Servis Aktif',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.tasks,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
              
              // Indikator Tambahan: Jumlah Pengadaan Suku Cadang Luar saat ini
              if (ticket.externalProcurements.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '${ticket.externalProcurements.length} Nota Pembelian Suku Cadang Terinput',
                        style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}