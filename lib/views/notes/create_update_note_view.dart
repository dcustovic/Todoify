import 'package:flutter/material.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/utilities/loading_indicator.dart';

import '../../services/crud/notes_service.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  DatabaseNote? _note;
  late final NotesServiceDb _notesServiceDb;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesServiceDb = NotesServiceDb();
    _textController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    //_notesServiceDb.close();
    _textController.dispose();
    _deleteNoteIfTextIsEmpty();
    _saveNoteWhenTextNotEmpty();

    super.dispose();
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    // editing note through arguments
    final noteArgs =
        ModalRoute.of(context)?.settings.arguments as DatabaseNote?;

    if (noteArgs != null) {
      _note = noteArgs;
      _textController.text = noteArgs.text;
      return noteArgs;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final email = AuthService.firebase().currentUser!.email;
    final owner = await _notesServiceDb.getUser(email: email);
    final newNote = await _notesServiceDb.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServiceDb.deleteNote(id: note.id);
    }
  }

  void _saveNoteWhenTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (text.isNotEmpty && note != null) {
      await _notesServiceDb.updateNote(
        note: note,
        text: text,
      );
    }
  }

  void _textListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textController.text;
    await _notesServiceDb.updateNote(note: note, text: text);
  }

  void _setupTextListener() async {
    _textController.removeListener(_textListener);
    _textController.addListener(_textListener);
  }

  @override
  Widget build(BuildContext context) {
    final noteArgs =
        ModalRoute.of(context)?.settings.arguments as DatabaseNote?;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        title: noteArgs != null
            ? const Text("Edit Task")
            : const Text("Create a New Task"),
        titleSpacing: 20,
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data;

              _setupTextListener();

              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: PhysicalShape(
                    color: const Color.fromARGB(94, 29, 8, 63),
                    elevation: 1,
                    shadowColor: const Color.fromARGB(34, 33, 0, 87),
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.white70),
                          hintText: 'What must you do?',
                          //fillColor: Colors.white60,
                        ),
                      ),
                    )),
              );

            default:
              return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}
