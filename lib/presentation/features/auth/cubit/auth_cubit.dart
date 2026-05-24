import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  /// Diperlukan saat aplikasi pertama kali dibuka (Splash Screen) 
  /// untuk mendeteksi apakah mekanik sudah login sebelumnya.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.getAuthenticatedUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  /// Eksekusi login mekanik
  Future<void> loginWithEmail({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signIn(email: email, password: password);
      emit(Authenticated(user));
    } catch (e) {
      // Menangkap pesan error kustom dari repository impl (misal: Salah role, Akun nonaktif)
      final clearMessage = e.toString().replaceAll('Exception: ', '');
      emit(Unauthenticated(errorMessage: clearMessage));
    }
  }

  /// Eksekusi logout mekanik
  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.signOut();
    emit(const Unauthenticated());
  }
}