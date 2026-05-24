// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

/// Fungsi utama untuk menginisialisasi semua dependency yang telah dianotasi.
/// Fungsi ini wajib dipanggil di main.dart sebelum runApp().
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // meng-generate sebagai extension method pada GetIt
)
Future<void> configureDependencies() async {
  await getIt.init();
}