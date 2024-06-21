import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/bloc/auth_service_bloc.dart';
import 'package:flutter_chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  TextEditingController emailContr = TextEditingController();
  TextEditingController passwordContr = TextEditingController();
  final _key = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _key,
      home: Scaffold(
        body: BlocProvider(
          create: (context) => AuthServiceBloc(),
          child: BlocBuilder<AuthServiceBloc, AuthServiceState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginPageInputField(label: 'Email', controller: emailContr),
                    const SizedBox(
                      height: 15,
                    ),
                    LoginPageInputField(
                        label: 'Password', controller: passwordContr),
                    const SizedBox(
                      height: 15,
                    ),
                    FilledButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 187, 58, 58),
                          ),
                          shape: WidgetStatePropertyAll(LinearBorder()),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 65))),
                      onPressed: () async {
                        if (emailContr.text.isEmpty ||
                            passwordContr.text.isEmpty) {
                          _key.currentState!.showSnackBar(SnackBar(
                              content: Text('No email or password is given.')));
                        } else {
                          try {
                            context.read<AuthServiceBloc>().add(
                                SignIn(emailContr.text, passwordContr.text));
                          } on FirebaseAuthException catch (e) {
                            _key.currentState!.showSnackBar(
                                SnackBar(content: Text(e.message!)));
                          }
                        }
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginPageInputField extends StatelessWidget {
  LoginPageInputField(
      {super.key, required this.label, required this.controller});
  final String label;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Color.fromARGB(255, 204, 204, 204),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            )));
  }
}
