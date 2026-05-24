import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> signIn({required String email, required String password}) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userModel == null) {
        throw Exception('Data pengguna tidak ditemukan di sistem.');
      }

      // VALIDASI MUTLAK: Tolak akses jika bukan mekanik atau akun tidak aktif
      if (userModel.role != 'mechanic') {
        await _remoteDataSource.signOut();
        throw Exception('Akses Ditolak: Aplikasi ini khusus untuk operasional Mekanik.');
      }

      if (!userModel.isActive) {
        await _remoteDataSource.signOut();
        throw Exception('Akses Ditolak: Akun Anda telah dinonaktifkan oleh Admin/Owner.');
      }

      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    final userModel = await _remoteDataSource.getCurrentUserData();
    if (userModel == null) return null;

    // Proteksi tambahan saat pengecekan otomatis (Splash/Auto-login)
    if (userModel.role != 'mechanic' || !userModel.isActive) {
      await _remoteDataSource.signOut();
      return null;
    }

    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}