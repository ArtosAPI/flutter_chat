part of 'auth_service_bloc.dart';

@immutable
sealed class AuthServiceEvent {}

class SignIn extends AuthServiceEvent{
  SignIn(this.email, this.password);
  final String email, password;
}