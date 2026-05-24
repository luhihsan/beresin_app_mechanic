// lib/presentation/features/ticket/cubit/ticket_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/external_procurement_entity.dart';
import '../../../../domain/repositories/service_ticket_repository.dart';
import 'ticket_state.dart';

@injectable
class TicketCubit extends Cubit<TicketState> {
  final ServiceTicketRepository _repository;
  StreamSubscription? _ticketSubscription;

  TicketCubit(this._repository) : super(const TicketInitial());

  /// Memulai pemantauan (listening) tiket secara realtime berbasis ID Mekanik.
  void watchMechanicTickets(String mechanicId) {
    emit(const TicketLoading());
    
    // Batalkan subscription lama jika ada untuk mencegah kebocoran memori (memory leak)
    _ticketSubscription?.cancel();

    _ticketSubscription = _repository.getTicketsByMechanic(mechanicId).listen(
      (tickets) {
        emit(TicketLoaded(tickets));
      },
      onError: (error) {
        emit(TicketError(error.toString()));
      },
    );
  }

  /// Menambahkan nota pembelian suku cadang luar oleh mekanik.
  Future<void> submitExternalProcurement({
    required String ticketDocId,
    required String partName,
    required String supplierStore,
    required int cost, // Nominal uang murni Integer (Anti-Floating Point)
    required String receiptPhotoUrl,
  }) async {
    // Simpan state terakhir (daftar tiket saat ini) agar UI tidak blank saat proses submit
    final currentState = state;
    
    try {
      final procurement = ExternalProcurementEntity(
        partName: partName,
        supplierStore: supplierStore,
        cost: cost,
        receiptPhotoUrl: receiptPhotoUrl,
      );

      await _repository.addExternalProcurement(
        ticketDocumentId: ticketDocId,
        procurement: procurement,
      );
      
      // Catatan: Firestore stream akan otomatis memicu update ke UI secara realtime,
      // sehingga kita tidak perlu memanggil ulang fungsi getTickets secara manual.
    } catch (e) {
      emit(TicketError('Gagal menambahkan pengadaan: ${e.toString()}'));
      // Kembalikan ke state data sebelumnya setelah menampilkan pesan error
      if (currentState is TicketLoaded) {
        emit(currentState);
      }
    }
  }

  @override
  Future<void> close() {
    // Wajib memutus aliran stream ketika Cubit dihancurkan demi performa memori RAM
    _ticketSubscription?.cancel();
    return super.close();
  }
}