part of 'auth_service_bloc.dart';

@immutable
sealed class AuthServiceEvent {}

class SignIn extends AuthServiceEvent{
  SignIn(this.email, this.password);
  final String email, password;
}

class SignUp extends AuthServiceEvent{
  SignUp(this.name, this.email, this.password);
  final String name, email, password;
}