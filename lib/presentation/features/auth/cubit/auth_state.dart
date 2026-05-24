import '../../../../domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? errorMessage;
  const Unauthenticated({this.errorMessage});
}