// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/services/cloud/cloud_note.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_firebase.dart';
import 'package:notes_flutter/utilities/loading_indicator.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  CloudNote? _note;
  DateTime _selectedDate = DateTime.now();

  final FocusNode _focusInput = FocusNode();
  final FocusNode _focusInput2 = FocusNode();
  late final CloudStorageFirebase _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _textControllerDescription;

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
    _textController = TextEditingController();
    _textControllerDescription = TextEditingController();
  }

  @override
  void dispose() {
    //_notesService.close();
    _textController.dispose();
    _textControllerDescription.dispose();
    _deleteNoteIfTitleIsEmpty();
    _saveNoteWhenTitleNotEmpty();
    super.dispose();
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // EDIT notes through arguments
    final noteArgs = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    if (noteArgs != null) {
      _note = noteArgs;
      _textController.text = noteArgs.text;
      _textControllerDescription.text = noteArgs.description as String;

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

  void _saveNoteWhenTitleNotEmpty() async {
    final note = _note;
    final title = _textController.text;
    final description = _textControllerDescription.text;

    if (title.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: title,
        description: description,
        date: _selectedDate,
        completed: false,
      );
    }
  }

  void _deleteNoteIfTitleIsEmpty() {
    final note = _note;
    final title = _textController.text;

    if (title.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _textListener() async {
    final note = _note;
    if (note == null) return;

    final title = _textController.text;
    final description = _textControllerDescription.text;

    await _notesService.updateNote(
      documentId: note.documentId,
      text: title,
      description: description,
      date: _selectedDate,
      completed: false,
    );
  }

  void _setupTextListener() async {
    _textController.removeListener(_textListener);
    _textController.addListener(_textListener);
  }

  _getDateFromUser() async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2009),
      lastDate: DateTime(2099),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 95, 81, 223),
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 95, 81, 223),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (datePicker != null) {
      setState(() {
        _selectedDate = datePicker;
      });
    }
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.white70,
      actions: [
        KeyboardActionsItem(focusNode: _focusInput, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: _focusInput2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteArgs = ModalRoute.of(context)?.settings.arguments as CloudNote?;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      appBar: AppBar(
        leading:
            noteArgs != null ? const BackButton(color: Colors.white) : null,
        title: noteArgs != null
            ? const Text("Edit Task")
            : const Text("Create a New Task"),
        titleSpacing: 20.5,
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

              return FadeIn(
                duration: const Duration(seconds: 1),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: KeyboardActions(
                    config: _buildConfig(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          readOnly: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                          decoration: InputDecoration(
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
                            suffixIcon: InkWell(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  size: 22,
                                ),
                                onPressed: () {
                                  _getDateFromUser();
                                },
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                            ),
                            hintText:
                                DateFormat.yMMMMEEEEd().format(_selectedDate),
                            //fillColor: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _textController,
                          focusNode: _focusInput,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                          cursorColor: Colors.deepOrange,
                          decoration: InputDecoration(
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
                            hintText: 'Title',

                            //fillColor: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _textControllerDescription,
                          focusNode: _focusInput2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                          cursorColor: Colors.deepOrange,
                          decoration: InputDecoration(
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
                            hintText: 'Description',
                            //fillColor: Colors.white60,
                          ),
                        ),
                      ],
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
