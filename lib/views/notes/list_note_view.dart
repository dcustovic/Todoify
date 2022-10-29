import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../services/crud/notes_service.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class ListNoteView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback deleteNote;
  const ListNoteView(
      {super.key, required this.notes, required this.deleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            style: const TextStyle(color: Colors.white),
            //maxLines: 1,
            //softWrap: true,
            //overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () {
              deleteNote(note);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
