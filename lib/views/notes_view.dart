import 'package:flutter/material.dart';
import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';

import '../utilities/show_dialog_messages.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final wantsToLogout = await showLogoutMessage(context);

                    if (wantsToLogout) {
                      await AuthService.firebase().logOut();

                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text("Log out")),
                ];
              },
            )
          ],
        ),
        body: const Text("Welcome to my app"));
  }
}
