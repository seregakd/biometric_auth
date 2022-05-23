import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(AuthInitial()) {
    on<AuthInitEvent>(_onAuthInit);
    on<AuthEvent>(_onAuth);
  }

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  void _onAuthInit(AuthInitEvent event, Emitter<LoginState> emit) async {
    bool isSupported = await auth.isDeviceSupported();
    if (isSupported) {
      _supportState = _SupportState.supported;
      emit(Auth());
    } else {
      _supportState = _SupportState.unsupported;
      emit(Error());
    }
  }

  void _onAuth(AuthEvent event, Emitter<LoginState> emit) async {
    await _authenticate();
    if (_authorized == 'Authorized') {
      emit(ToHome());
      emit(Auth());
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    _canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
    }
    _availableBiometrics = availableBiometrics;
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
      _authorized = 'Authenticating';

      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      _isAuthenticating = false;
    } on PlatformException catch (e) {
      _isAuthenticating = false;
      _authorized = 'Error - ${e.message}';
      return;
    }
    if (authenticated) {
      _authorized = 'Authorized';
    } else {
      _authorized = 'Not Authorized';
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    _isAuthenticating = false;
  }

}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}