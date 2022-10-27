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

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final email = AuthService.firebase().currentUser!.email!;
    final owner = await _notesServiceDb.getUser(email: email);
    return await _notesServiceDb.createNote(owner: owner);
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        title: const Text("Add New Note"),
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data;
              _setupTextListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: "What must you do?"),
              );
            default:
              return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}
