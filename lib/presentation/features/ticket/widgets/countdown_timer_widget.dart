// lib/presentation/features/ticket/widgets/countdown_timer_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimerWidget({super.key, required this.targetTime});

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  Duration _remainingDuration = Duration.zero;
  bool _isOperationalHours = true;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateRemainingTime();
      }
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    
    // Cek Batasan Operasional Jam Kerja Bengkel (08:00 - 16:00 WIB)
    if (now.hour < 8 || now.hour >= 16) {
      _isOperationalHours = false;
    } else {
      _isOperationalHours = true;
    }

    setState(() {
      _remainingDuration = widget.targetTime.difference(now);
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return "WAKTU HABIS / OVERDUE";
    
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (days > 0) {
      return "$days Hari, $hours:$minutes:$seconds";
    }
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCritical = _remainingDuration.inHours <= 24;
    final Color statusColor = _remainingDuration.isNegative 
        ? Colors.red.shade900 
        : isCritical ? Colors.red.shade700 : Colors.blue.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withAlpha(60), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.hourglass_top_rounded, size: 16, color: statusColor),
                  const SizedBox(width: 6),
                  const Text(
                    'SISA WAKTU PENGERJAAN:',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                  ),
                ],
              ),
              if (!_isOperationalHours && !_remainingDuration.isNegative)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(4)),
                  child: const Text('BENGKEL TUTUP', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDuration(_remainingDuration),
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w900, 
              color: _remainingDuration.isNegative ? Colors.red.shade800 : Colors.black87,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}