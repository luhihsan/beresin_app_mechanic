// lib/presentation/features/ticket/cubit/ticket_cubit.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/morning_shift_notification_service.dart';
import '../../../../domain/entities/external_procurement_entity.dart';
import '../../../../domain/repositories/service_ticket_repository.dart';
import 'ticket_state.dart';

@injectable
class TicketCubit extends Cubit<TicketState> {
  final ServiceTicketRepository _repository;
  final MorningShiftNotificationService _notificationService = MorningShiftNotificationService();
  StreamSubscription? _ticketSubscription;
  Timer? _minuteRoutineTimer;

  TicketCubit(this._repository) : super(const TicketInitial()) {
    _notificationService.initNotificationService();
  }

  void watchMechanicTickets(String mechanicId) {
    emit(const TicketLoading());
    _ticketSubscription?.cancel();
    _ticketSubscription = _repository.getTicketsByMechanic(mechanicId).listen(
      (tickets) {
        emit(TicketLoaded(tickets));
        
        // Evaluasi notifikasi instan setiap kali Firestore memancarkan data baru
        _notificationService.processMorningShiftAlerts(tickets);
        _notificationService.processAfternoonReminder(tickets);
        _notificationService.checkTickingDeadlines(tickets);
      },
      onError: (error) {
        emit(TicketError(error.toString()));
      },
    );

    // Jalankan pengecekan background berkala setiap 1 menit untuk berburu tenggat waktu kritis
    _minuteRoutineTimer?.cancel();
    _minuteRoutineTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (state is TicketLoaded) {
        final currentTickets = (state as TicketLoaded).tickets;
        _notificationService.checkTickingDeadlines(currentTickets);
        _notificationService.processAfternoonReminder(currentTickets);
      }
    });
  }

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

  Future<void> completeService({
    required String ticketDocId,
    required String ticketId,
    required int kmService,
    required int invoiceAmount,
    required String mechanicNotes,
    File? proofImage,
  }) async {
    try {
      await _repository.completeTicketTask(
        ticketDocumentId: ticketDocId,
        kmService: kmService,
        invoiceAmount: invoiceAmount,
        mechanicNotes: mechanicNotes,
        proofImage: proofImage,
      );
    } catch (e) {
      emit(TicketError('Gagal menyelesaikan servis: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _ticketSubscription?.cancel();
    _minuteRoutineTimer?.cancel();
    return super.close();
  }
}