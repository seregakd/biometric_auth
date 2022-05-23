part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class AuthInitial extends LoginState {}

class Auth extends LoginState {}
class Error extends LoginState {}

class ToHome extends LoginState {}
