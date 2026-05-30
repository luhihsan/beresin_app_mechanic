// lib/core/services/morning_shift_notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/service_ticket_entity.dart';

class MorningShiftNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotificationService() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
        
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Pemicu Awal Jam Kerja (08:00 WIB)
  void processMorningShiftAlerts(List<ServiceTicketEntity> activeTickets) async {
    final now = DateTime.now();

    for (var ticket in activeTickets) {
      if (ticket.status != 'processing' || ticket.targetCompletionTime == null) continue;

      final sisaWaktuMilidetik = ticket.targetCompletionTime!.difference(now).inMilliseconds;
      final double sisaHari = sisaWaktuMilidetik / (1000 * 60 * 60 * 24);

      if (sisaHari <= 1 && sisaHari > 0) {
        await _showLocalNotification(
          id: ticket.ticketId.hashCode,
          title: '🚨 BATAS WAKTU KRITIS: Pelat ${ticket.carDetails.plate}',
          body: 'Sisa waktu pengerjaan unit tinggal beberapa jam lagi. Segera tuntaskan perbaikan komponen sebelum batas waktu berakhir!',
        );
      } else if (sisaHari > 1) {
        await _showLocalNotification(
          id: ticket.ticketId.hashCode,
          title: '🔧 Pengingat Tugas Hari Ini: Pelat ${ticket.carDetails.plate}',
          body: 'Unit kendaraan ${ticket.carDetails.brand} ${ticket.carDetails.type} dialokasikan selesai dalam ${sisaHari.toStringAsFixed(0)} hari ke depan. Selamat bekerja.',
        );
      }
    }
  }

  /// SINKRONISASI BARU: Pemicu Alarm Selesai Istirahat Siang (Setiap Hari Kerja Jam 13:00 WIB)
  void processAfternoonReminder(List<ServiceTicketEntity> activeTickets) async {
    final now = DateTime.now();
    // Validasi Hari Kerja Berdasarkan Kalender Operasional Bengkel (Senin = 1 s.d Sabtu = 6)
    if (now.weekday >= 1 && now.weekday <= 6) {
      for (var ticket in activeTickets) {
        if (ticket.status != 'processing' || ticket.targetCompletionTime == null) continue;
        
        final sisaDurasi = ticket.targetCompletionTime!.difference(now);
        if (sisaDurasi.isNegative) continue;

        await _showLocalNotification(
          id: ticket.ticketId.hashCode + 100,
          title: '☀️ Shift Siang Dimulai: Pelat ${ticket.carDetails.plate}',
          body: 'Waktu istirahat siang berakhir. Mari lanjutkan kembali penanganan unit ${ticket.carDetails.brand} ${ticket.carDetails.type}!',
        );
      }
    }
  }

  /// SINKRONISASI BARU: Pemicu Batas Waktu Menit Kritis (1 Jam & 30 Menit Terakhir)
  void checkTickingDeadlines(List<ServiceTicketEntity> activeTickets) async {
    final now = DateTime.now();
    for (var ticket in activeTickets) {
      if (ticket.status != 'processing' || ticket.targetCompletionTime == null) continue;
      
      final sisaMenit = ticket.targetCompletionTime!.difference(now).inMinutes;

      if (sisaMenit <= 60 && sisaMenit > 59) {
        await _showLocalNotification(
          id: ticket.ticketId.hashCode + 200,
          title: '⚠️ 1 JAM TERAKHIR: Pelat ${ticket.carDetails.plate}',
          body: 'Batas waktu pengerjaan tinggal 1 jam lagi! Segera lakukan finalisasi komponen kendaraan.',
        );
      } else if (sisaMenit <= 30 && sisaMenit > 29) {
        await _showLocalNotification(
          id: ticket.ticketId.hashCode + 300,
          title: '🚨 30 MENIT TERAKHIR: Pelat ${ticket.carDetails.plate}',
          body: 'Mendekati Batas Akhir! Sisa waktu sisa 30 menit. Segera persiapkan input angka odometer selesai!',
        );
      }
    }
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'morning_shift_channel_id',
      'Alerts Perbaikan Bengkel',
      channelDescription: 'Notifikasi batas waktu pengerjaan ekosistem bengkel.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    
    await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }
}