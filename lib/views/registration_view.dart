import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as tools show log;

import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/utilities/show_dialog_messages.dart';

import '../constants/diameters.dart';

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
      backgroundColor: const Color(0xFFEEEEEE),
      body: Stack(
        children: <Widget>[
          Positioned(
            right: -getSmallDiameter(context) / 3,
            top: -getSmallDiameter(context) / 3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 42, 1, 156),
                    Color.fromARGB(255, 223, 206, 255)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            left: -getBiglDiameter(context) / 4,
            top: -getBiglDiameter(context) / 4,
            child: Container(
              width: getBiglDiameter(context),
              height: getBiglDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 50, 0, 189),
                    Color.fromARGB(255, 212, 198, 250)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: const Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: "Pacifico",
                    fontSize: 40,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 3.0,
                        color: Color.fromARGB(197, 0, 0, 0),
                      ),
                      Shadow(
                        offset: Offset(5, 5),
                        blurRadius: 8.0,
                        color: Color.fromARGB(124, 98, 0, 255),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -getBiglDiameter(context) / 2,
            bottom: -getBiglDiameter(context) / 2,
            child: Container(
              width: getBiglDiameter(context),
              height: getBiglDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFF3E9EE)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 9,
                        offset:
                            const Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _email,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          icon: const Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 139, 139, 139),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                          labelText: "Email",
                          enabledBorder: InputBorder.none,
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.vpn_key,
                                color: Color.fromARGB(255, 139, 139, 139)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                            labelText: "Password",
                            enabledBorder: InputBorder.none,
                            labelStyle: const TextStyle(color: Colors.grey)),
                      ),
                      TextField(
                        controller: _confirmPassword,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.vpn_key_outlined,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                            labelText: "Confirm password",
                            enabledBorder: InputBorder.none,
                            labelStyle: const TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 114, 98, 253),
                                Color.fromARGB(255, 114, 98, 253)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              final email = _email.text.trim();
                              final password = _password.text.trim();
                              final confirmPassword =
                                  _confirmPassword.text.trim();

                              bool isPasswordConfirmed() {
                                if (password == confirmPassword) {
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
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  currentUser?.sendEmailVerification();

                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .pushNamed(verifyEmailRoute);
                                } else {
                                  showErrorMessage(
                                      context, 'Password does not match.');
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  await showErrorMessage(
                                      context, 'User not found.');
                                } else if (e.code == 'wrong-password') {
                                  await showErrorMessage(
                                      context, "Wrong user credentials.");
                                } else if (e.code == 'invalid-email') {
                                  await showErrorMessage(
                                      context, 'Invalid email address.');
                                } else {
                                  await showErrorMessage(
                                      context, 'Error: ${e.code}');
                                }
                              } catch (e) {
                                await showErrorMessage(context, e.toString());
                              }
                            },
                            child: const Center(
                              child: Text(
                                "REGISTER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "ALREADY HAVE AN ACCOUNT?",
                      style: TextStyle(
                          fontSize: 11,
                          color: Color.fromARGB(255, 141, 141, 141),
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 114, 98, 253),
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
