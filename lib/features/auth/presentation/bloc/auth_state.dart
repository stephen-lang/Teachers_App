part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final  User userme;

  AuthSuccess({  required this.userme});
  
}
class AuthSignUpSuccess extends AuthState {
  final User userme;

  AuthSignUpSuccess({required this.userme});
}
final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}
class AuthSignedOut extends AuthState {
  
}
