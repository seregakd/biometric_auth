import 'package:biometric_auth/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc()..add(AuthInitEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen"),
        ),
        body: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is ToHome) {
                _nextScreen(context);
              }
            },
            builder: (context, state) {
              if (state is AuthInitial) {
                return const Center(child: SingleChildScrollView());
              }
              if (state is Auth) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          //            const SizedBox(height: 100,),
                      ElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text('Authenticate '),
                            Icon(Icons.fingerprint),
                          ],
                        ),
                        onPressed: () => context.read<LoginBloc>().add(AuthEvent()),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
          ),
        ),
    );
  }

  void _nextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
