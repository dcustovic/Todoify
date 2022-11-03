import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';
import '../utilities/show_dialog_messages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 95, 81, 223),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 90,
              ),
              const CircleAvatar(
                radius: 70,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 130,
                  color: Colors.white,
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    final wantsToLogout = await showLogoutMessage(context);

                    if (wantsToLogout) {
                      await AuthService.firebase().logOut();

                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  },
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ))
            ],
          ),
        ));
  }
}
