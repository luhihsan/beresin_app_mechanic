// lib/presentation/features/ticket/cubit/ticket_cubit.dart
import 'dart:async';
import 'dart:io';
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

  /// Membuka aliran stream real-time untuk memantau tiket aktif montir (Langkah A)
  void watchMechanicTickets(String mechanicId) {
    emit(const TicketLoading());
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

  /// Memperbarui mutasi pelacakan status tiket (waiting -> processing)
  Future<void> updateStatus({
    required String ticketDocId,
    required String newStatus,
  }) async {
    try {
      await _repository.updateTicketStatus(
        ticketDocumentId: ticketDocId,
        status: newStatus,
      );
    } catch (e) {
      emit(TicketError('Gagal memperbarui status: ${e.toString()}'));
    }
  }

  /// Mengirimkan dokumentasi pengadaan suku cadang eksternal luar bengkel
  Future<void> submitExternalProcurement({
    required String ticketDocId,
    required String ticketId,
    required String partName,
    required String supplierStore,
    required int cost,
    required File? imageFile,
  }) async {
    try {
      final procurement = ExternalProcurementEntity(
        partName: partName,
        supplierStore: supplierStore,
        cost: cost,
        receiptPhotoUrl: '',
      );
      await _repository.addExternalProcurement(
        ticketDocumentId: ticketDocId,
        ticketId: ticketId,
        procurement: procurement,
        imageFile: imageFile,
      );
    } catch (e) {
      emit(TicketError('Gagal menambah pengadaan: ${e.toString()}'));
    }
  }

  /// FIX ERROR: Protokol Penyelesaian Tugas Lapangan (Langkah C)
  /// Fungsi ini sekarang menerima data kilometer aktual dan nominal tagihan final
  Future<void> completeService({
    required String ticketDocId,
    required int kmService,
    required int invoiceAmount,
  }) async {
    final currentState = state;
    emit(const TicketLoading());
    try {
      await _repository.completeTicketTask(
        ticketDocumentId: ticketDocId,
        kmService: kmService,
        invoiceAmount: invoiceAmount,
      );
    } catch (e) {
      emit(TicketError('Gagal menyelesaikan servis: ${e.toString()}'));
      if (currentState is TicketLoaded) {
        emit(currentState);
      }
    }
  }

  @override
  Future<void> close() {
    _ticketSubscription?.cancel();
    return super.close();
  }
}