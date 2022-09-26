import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration:
                          const InputDecoration(hintText: "Enter email")),
                  TextField(
                      controller: _password,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration:
                          const InputDecoration(hintText: "Enter password")),
                  TextButton(
                    child: const Text("Login"),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);
                        print(
                            "ULOGIRANI USER JEEEEEEEEEEEEEEEEE: $userCredential");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print("User not found");
                        } else if (e.code == 'wrong-password') {
                          print("Wrong password");
                        }
                      }
                    },
                  ),
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
