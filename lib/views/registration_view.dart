import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Column(
      children: [
        TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter email")),
        TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter password")),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;

            try {
              final UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print("Weak password");
              } else if (e.code == 'email-already-in-use') {
                print("Email already in use");
              } else if (e.code == 'invalid-email') {
                print("Invalid email entered");
              }
            }
          },
          child: const Text("Register"),
        ),
      ],
    );
  }
}
