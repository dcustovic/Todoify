import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as tools show log;

import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/utilities/show_dialog_messages.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    ;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  hintText: "Enter email",
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  hintText: "Confirm password",
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  bool isPasswordConfirmed() {
                    if (_password.text.trim() == _confirmPassword.text.trim()) {
                      return true;
                    } else {
                      return false;
                    }
                  }

                  try {
                    if (isPasswordConfirmed()) {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      final currentUser = FirebaseAuth.instance.currentUser;
                      currentUser?.sendEmailVerification();

                      if (!mounted) return;
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    } else {
                      showErrorMessage(context, 'Password does not match.');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      await showErrorMessage(context, 'Wrong password.');
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorMessage(
                          context, 'Email is already in use.');
                    } else if (e.code == 'invalid-email') {
                      await showErrorMessage(context, 'Invalid email address.');
                    } else {
                      await showErrorMessage(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    await showErrorMessage(context, e.toString());
                  }
                },
                child: const Text("Register"),
              ),
              const SizedBox(
                height: 7,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text("Already have an account?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
