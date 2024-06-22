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
  const MyApp({super.key});
  static final GlobalKey<ScaffoldMessengerState> messangerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messangerKey,
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  SignInPage({
    super.key,
  });

  final TextEditingController emailContr = TextEditingController();
  final TextEditingController passwordContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthServiceBloc(),
        child: BlocBuilder<AuthServiceBloc, AuthServiceState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignPageInputField(label: 'Email', controller: emailContr),
                  const SizedBox(
                    height: 15,
                  ),
                  SignPageInputField(
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
                        minimumSize:
                            WidgetStatePropertyAll(Size(double.infinity, 65))),
                    onPressed: () async {
                      if (emailContr.text.isEmpty ||
                          passwordContr.text.isEmpty) {
                        MyApp.messangerKey.currentState!.showSnackBar(SnackBar(
                            content: Text('No email or password is given.')));
                      } else {
                        try {
                          context
                              .read<AuthServiceBloc>()
                              .add(SignIn(emailContr.text, passwordContr.text));

                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Placeholder()));
                        } on FirebaseAuthException catch (e) {
                          MyApp.messangerKey.currentState!.showSnackBar(
                              SnackBar(content: Text(e.message!)));
                        }
                      }
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUpPage()));
                      },
                      child: const Text('or sign up'))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController nameContr = TextEditingController();
  TextEditingController emailContr = TextEditingController();
  TextEditingController passwordContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => AuthServiceBloc(),
      child: BlocBuilder<AuthServiceBloc, AuthServiceState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignPageInputField(label: 'Name', controller: nameContr),
                const SizedBox(
                  height: 15,
                ),
                SignPageInputField(label: 'Email', controller: emailContr),
                const SizedBox(
                  height: 15,
                ),
                SignPageInputField(
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
                      minimumSize:
                          WidgetStatePropertyAll(Size(double.infinity, 65))),
                  onPressed: () async {
                    if (nameContr.text.isEmpty ||
                        emailContr.text.isEmpty ||
                        passwordContr.text.isEmpty) {
                      MyApp.messangerKey.currentState!.showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'No name, email or password is given.')));
                    } else {
                      try {
                        context.read<AuthServiceBloc>().add(SignUp(
                            nameContr.text,
                            emailContr.text,
                            passwordContr.text));

                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Placeholder()));
                            
                      } on FirebaseAuthException catch (e) {
                        MyApp.messangerKey.currentState!
                            .showSnackBar(SnackBar(content: Text(e.message!)));
                      }
                    }
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignInPage()));
                    },
                    child: const Text('or sign in'))
              ],
            ),
          );
        },
      ),
    ));
  }
}

class SignPageInputField extends StatelessWidget {
  SignPageInputField(
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
