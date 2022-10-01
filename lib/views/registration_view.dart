import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as tools show log;

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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
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
                final UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: password);
                tools.log("REGISTRATION:");
                tools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  tools.log("User not found");
                  tools.log("Wrong password");
                  ("Weak password");
                } else if (e.code == 'email-already-in-use') {
                  tools.log("User not found");
                  tools.log("Wrong password");
                  ("Email already in use");
                } else if (e.code == 'invalid-email') {
                  tools.log("User not found");
                  tools.log("Wrong password");
                  ("Invalid email entered");
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text("Already have an account?"),
          )
        ],
      ),
    );
  }
}
