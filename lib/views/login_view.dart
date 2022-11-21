import 'package:flutter/material.dart';

import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/services/auth/auth_exceptions.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';

import '../utilities/show_dialog_messages.dart';
import '../utilities/wave_clipper.dart';

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
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
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
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: const Color.fromARGB(255, 36, 5, 77),
                height: 245,
              ),
            ),
          ),
          ClipPath(
            //upper clippath with less height
            clipper: WaveClipper(),
            child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              color: const Color.fromARGB(198, 25, 2, 53),
              height: 230,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 33,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          /*          Positioned(
            right: -getSmallDiameter(context) / 3,
            top: -getSmallDiameter(context) / 3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 27, 0, 71),
                    Color.fromARGB(255, 27, 0, 71),
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
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 27, 0, 71),
                    Color.fromARGB(255, 27, 0, 71),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Text(
                  "Login",
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
            right: -getBiglDiameter(context) / 11,
            bottom: -getBiglDiameter(context) / 2,
            child: Container(
              width: getBiglDiameter(context),
              height: getBiglDiameter(context),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 27, 0, 71),
              ),
            ),
          ), */
          Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(232, 255, 255, 255),
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 95, 95, 95)
                            .withOpacity(0.5),
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
                        keyboardType: TextInputType.emailAddress,
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
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(153, 34, 8, 68),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              final email = _email.text;
                              final password = _password.text;

                              try {
                                await AuthService.firebase().logIn(
                                  email: email,
                                  password: password,
                                );

                                final currentUser =
                                    AuthService.firebase().currentUser;

                                if (currentUser?.isEmailVerified ?? false) {
                                  if (!mounted) return;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    homeRoute,
                                    (route) => false,
                                  );
                                } else {
                                  if (!mounted) return;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    verifyEmailRoute,
                                    (route) => false,
                                  );
                                }
                              } on UserNotFoundAuthException {
                                await showErrorMessage(
                                    context, 'User not found.');
                              } on WrongPasswordAuthException {
                                await showErrorMessage(
                                    context, "Wrong user credentials.");
                              } on EmailInvalidAuthException {
                                await showErrorMessage(
                                    context, 'Invalid email address.');
                              } on GenericAuthException {
                                await showErrorMessage(
                                    context, 'Authentication problem.');
                              }
                            },
                            child: const Center(
                              child: Text(
                                "LOGIN",
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "DON'T HAVE AN ACCOUNT?",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 10,
                            color: Color.fromARGB(255, 231, 217, 253),
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
