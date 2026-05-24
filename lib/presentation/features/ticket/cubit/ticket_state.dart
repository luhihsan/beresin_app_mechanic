// lib/presentation/features/ticket/cubit/ticket_state.dart
import '../../../../domain/entities/service_ticket_entity.dart';

sealed class TicketState {
  const TicketState();
}

/// Keadaan awal saat halaman dimuat
class TicketInitial extends TicketState {
  const TicketInitial();
}

/// Keadaan saat aplikasi sedang menunggu stream data atau memproses mutasi
class TicketLoading extends TicketState {
  const TicketLoading();
}

/// Keadaan sukses saat data tiket mekanik berhasil didapatkan secara realtime
class TicketLoaded extends TicketState {
  final List<ServiceTicketEntity> tickets;
  const TicketLoaded(this.tickets);
}

/// Keadaan gagal apabila terjadi kendala jaringan atau masalah hak akses
class TicketError extends TicketState {
  final String message;
  const TicketError(this.message);
}

/// Keadaan khusus untuk menangani feedback UI saat mekanik menambahkan pengadaan barang
class ProcurementActionState extends TicketState {
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  const ProcurementActionState({
    required this.isSubmitting,
    this.errorMessage,
    required this.isSuccess,
  });
}