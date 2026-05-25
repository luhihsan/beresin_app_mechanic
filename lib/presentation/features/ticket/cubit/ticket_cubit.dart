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

  /// Memulai pemantauan (listening) tiket secara realtime berbasis ID Mekanik.
  /// Aliran data (stream) dari Cloud Firestore akan dipantau secara aktif.
  void watchMechanicTickets(String mechanicId) {
    emit(const TicketLoading());
    
    // Membatalkan langganan stream sebelumnya jika ada untuk mencegah kebocoran memori (memory leak)
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

  /// Menambahkan nota pembelian suku cadang luar oleh mekanik ke Cloud Firestore.
  /// Fungsi ini mengelola alur konversi objek berkas fisik [File] dari kamera 
  /// menjadi alamat unduhan digital (Download URL) sebelum disimpan ke basis data.
  Future<void> submitExternalProcurement({
    required String ticketDocId,
    required String ticketId,
    required String partName,
    required String supplierStore,
    required int cost, // Nominal harga modal wajib bertipe data Integer (Anti-Floating Point Error)
    required File? imageFile, // Menggunakan objek File mentah dari jepretan kamera perangkat
  }) async {
    // Menyimpan keadaan (state) terakhir sebelum proses mutasi data dilakukan
    final currentState = state;
    emit(const TicketLoading());
    
    try {
      String uploadedPhotoUrl = 'https://firebasestorage.googleapis.com/v0/b/mock-receipt.jpg';
      
      // LOGIKA INTEGRASI: Jika berkas gambar dari kamera tersedia, lakukan proses unggah
      if (imageFile != null) {
        // TODO: Panggil fungsi upload dari StorageRemoteDataSource atau Repository
        // contoh: uploadedPhotoUrl = await _storageRepository.uploadImage(ticketId, imageFile);
      }

      final procurement = ExternalProcurementEntity(
        partName: partName,
        supplierStore: supplierStore,
        cost: cost,
        receiptPhotoUrl: uploadedPhotoUrl,
      );

      // Mengirimkan entitas bisnis pengadaan ke dalam repositori data
      await _repository.addExternalProcurement(
        ticketDocumentId: ticketDocId,
        procurement: procurement,
      );
      
      // Catatan: Aliran data (stream) Firestore yang aktif pada fungsi watchMechanicTickets 
      // akan otomatis memicu pembaruan antarmuka pengguna (UI emittance) secara realtime.
    } catch (e) {
      emit(TicketError('Gagal menambahkan pengadaan: ${e.toString()}'));
      
      // Mengembalikan keadaan antarmuka ke data Loaded sebelumnya jika terjadi kegagalan proses
      if (currentState is TicketLoaded) {
        emit(currentState);
      }
    }
  }

  /// Memperbarui status operasional pengerjaan servis pada Service Ticket secara atomik.
  /// Perubahan status ini akan memicu pembaruan data secara langsung pada Web Dashboard Admin/Owner.
  Future<void> updateStatus({
    required String ticketDocId,
    required String newStatus,
  }) async {
    final currentState = state;
    try {
      await _repository.updateTicketStatus(
        ticketDocumentId: ticketDocId, 
        status: newStatus,
      );
    } catch (e) {
      emit(TicketError('Gagal mengubah status operasional: ${e.toString()}'));
      
      if (currentState is TicketLoaded) {
        emit(currentState);
      }
    }
  }

  @override
  Future<void> close() {
    // Memutus aliran stream secara mutlak ketika komponen Cubit dihancurkan oleh sistem
    _ticketSubscription?.cancel();
    return super.close();
  }
}