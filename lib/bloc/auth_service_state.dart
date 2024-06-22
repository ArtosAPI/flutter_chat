part of 'auth_service_bloc.dart';

@immutable
sealed class AuthServiceState {}

final class AuthServiceInitial extends AuthServiceState {}

final class UserCreds extends AuthServiceState
{
  UserCreds(this.name, this.email);
  final String name, email;
}