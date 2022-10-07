import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as tools show log;

import 'package:notes_flutter/constants/routes.dart';

import '../utilities/show_dialog_messages.dart';

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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);

                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorMessage(context, 'User not found.');
                } else if (e.code == 'wrong-password') {
                  await showErrorMessage(context, "Wrong user credentials.");
                } else {
                  await showErrorMessage(context, 'Error: ${e.code}');
                }
              } catch (e) {
                await showErrorMessage(context, e.toString());
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Not registered?"),
          )
        ],
      ),
    );
  }
}
