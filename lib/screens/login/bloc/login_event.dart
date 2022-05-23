part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class AuthInitEvent extends LoginEvent {}

class AuthEvent extends LoginEvent {}
