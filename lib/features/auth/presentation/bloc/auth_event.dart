part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}


final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String displayName ;
  final String role;

  AuthSignUp({required this.email, required this.password, required this.displayName, required this.role, });
}
final class AuthLogin extends AuthEvent {
  final String email;
  final String password;
 

  AuthLogin({required this.email, required this.password, });
}

final class AuthIsUserLoggedIn extends AuthEvent{
  
}
final class AuthSignOut extends AuthEvent{
  
}