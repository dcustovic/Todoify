import 'package:flutter/material.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/services/cloud/cloud_note.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_firebase.dart';
import 'package:notes_flutter/utilities/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilities/show_dialog_messages.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  CloudNote? _note;

  late final CloudStorageFirebase _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    //_notesService.close();
    _textController.dispose();
    _deleteNoteIfTextIsEmpty();
    _saveNoteWhenTextNotEmpty();

    super.dispose();
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // editing note through arguments
    final noteArgs = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    if (noteArgs != null) {
      _note = noteArgs;
      _textController.text = noteArgs.text;
      return noteArgs;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser;
    final userId = currentUser?.id;
    final newNote = await _notesService.createNewNote(ownerId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteWhenTextNotEmpty() async {
    final note = _note;
    final currentText = _textController.text;

    if (currentText.isNotEmpty && note != null) {
      await _notesService.updateNote(
          documentId: note.documentId, text: currentText);
    }
  }

  void _textListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textController.text;

    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextListener() async {
    _textController.removeListener(_textListener);
    _textController.addListener(_textListener);
  }

  @override
  Widget build(BuildContext context) {
    final noteArgs = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        title: noteArgs != null
            ? const Text("Edit Task")
            : const Text("Create a New Task"),
        titleSpacing: 20.5,
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              final text = _textController.text;
              if (text.isNotEmpty) {
                Share.share('From app: $text');
              } else {
                showCannotShareEmptyNote(context);
              }
            },
          )
        ],
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
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
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
                      onChanged: (value) {
                        //shareText = value;
                      },
                    ),
                  ),
                ),
              );

            default:
              return const CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}
