import 'package:flutter/material.dart';
import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';

import '../../services/crud/notes_service.dart';
import '../../utilities/loading_indicator.dart';
import '../../utilities/show_dialog_messages.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesServiceDb _notesServiceDb;

  @override
  void initState() {
    _notesServiceDb = NotesServiceDb();
    super.initState();
  }

  @override
  void dispose() {
    //_notesServiceDb.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        elevation: 0,
        /*  actions: [
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
              return [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Color.fromARGB(255, 95, 81, 223),
                          ),
                        ),
                        Text('Log out'),
                      ],
                    )),
              ];
            },
          )
        ], */
      ),
      body: FutureBuilder(
        future: _notesServiceDb.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesServiceDb.allNotes,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text(
                        "loading notes...",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    default:
                      return const CustomLoadingIndicator();
                  }
                }),
              );

            default:
              return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}
