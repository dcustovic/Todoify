import 'package:flutter/material.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/views/notes/search_notes.dart';
import 'package:notes_flutter/views/notes/search_result_empty.dart';

import '../../constants/routes.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/cloud_storage_firebase.dart';
import '../../utilities/loading_indicator.dart';
import 'list_note_empty.dart';
import 'list_note_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final CloudStorageFirebase _notesService;

  String searchResult = '';

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        title: const Text("Search"),
        titleSpacing: 20.5,
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        elevation: 0,
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
                  return const SearchResultEmpty();
                }

                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.deepOrange),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        fillColor: const Color.fromARGB(94, 29, 8, 63),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13.5,
                        ),
                        hintText: 'Search all tasks',
                        //fillColor: Colors.white60,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchResult = value;
                        });
                      },
                    ),
                  ),
                  SearchNotes(
                    notes: allNotes,
                    searchResult: searchResult,
                  ),
                ]);
              } else {
                return const CustomLoadingIndicator();
              }
            default:
              return const CustomLoadingIndicator();
          }
        }),
      ),
    );
  }
}
