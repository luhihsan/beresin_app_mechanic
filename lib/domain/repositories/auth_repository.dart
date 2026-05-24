import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Proses masuk menggunakan email dan password.
  /// Mengembalikan [UserEntity] jika sukses dan memenuhi syarat role mekanik.
  Future<UserEntity> signIn({required String email, required String password});

  /// Memeriksa apakah ada sesi pengguna mekanik yang sedang aktif saat aplikasi dibuka.
  Future<UserEntity?> getAuthenticatedUser();

  /// Menghapus sesi login (Sign Out).
  Future<void> signOut();
}