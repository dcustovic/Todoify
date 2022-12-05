import 'package:flutter/material.dart';

import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_firebase.dart';
import 'package:notes_flutter/views/notes/list_note_empty.dart';
import 'package:notes_flutter/views/notes/list_note_view.dart';

import '../../constants/routes.dart';
import '../../services/cloud/cloud_note.dart';

import '../../utilities/loading_indicator.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String get userId => AuthService.firebase().currentUser!.id;
  late final CloudStorageFirebase _notesService;

  Icon actionIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text('Home');

  TextEditingController _controller = TextEditingController();
  String searchResult = '';
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        appBar: AppBar(
          title: appBarTitle,
          titleSpacing: 20.5,
          backgroundColor: const Color.fromARGB(255, 95, 81, 223),
          elevation: 0,
          actions: [
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close);
                    appBarTitle = TextField(
                      controller: _controller,
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.deepOrange,
                      decoration: const InputDecoration(
                          // prefixIcon: Icon(Icons.search, color: Colors.white),
                          contentPadding: EdgeInsets.only(left: 8),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          hintText: "Search all tasks...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          )),
                      onChanged: (value) {
                        setState(() {
                          searchResult = value;
                        });
                      },
                    );
                    isSearchActive = true;
                  } else {
                    setState(() {
                      actionIcon = const Icon(Icons.search);
                      appBarTitle = const Text('Home');
                      _controller.text = '';
                      searchResult = '';
                      isSearchActive = false;
                    });
                  }
                });
              },
            ),
          ],
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
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data;

                  if (allNotes!.isEmpty) {
                    return const ListNoteEmpty();
                  }

                  return ListNoteView(
                    notes: allNotes,
                    searchResult: searchResult,
                    isSearchActive: isSearchActive,
                    deleteNote: (CloudNote note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onEdit: (CloudNote note) {
                      Navigator.of(context)
                          .pushNamed(createOrUpdateNoteRoute, arguments: note);
                    },
                  );
                } else {
                  return const CustomLoadingIndicator();
                }
              default:
                return const CustomLoadingIndicator();
            }
          }),
        ));
  }
}
