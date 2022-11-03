import 'package:flutter/material.dart';
import '../../services/crud/notes_service.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class ListNoteView extends StatefulWidget {
  final List<DatabaseNote> notes;
  final NoteCallback deleteNote;
  final NoteCallback onEdit;

  const ListNoteView({
    super.key,
    required this.notes,
    required this.deleteNote,
    required this.onEdit,
  });

  @override
  State<ListNoteView> createState() => _ListNoteViewState();
}

class _ListNoteViewState extends State<ListNoteView> {
  final List<bool> _isFinished = List.generate(20, (i) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 13, right: 13),
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PhysicalShape(
            color: _isFinished[index]
                //const Color.fromARGB(108, 28, 0, 66)
                ? const Color.fromARGB(174, 23, 8, 43)
                : const Color.fromARGB(108, 55, 30, 90),
            elevation: 1.5,
            shadowColor: const Color.fromARGB(108, 33, 0, 87),
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: ListTile(
              title: Text(
                note.text,
                style: _isFinished[index]
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                    : null,
                //maxLines: 1,
                //softWrap: true,
                //overflow: TextOverflow.ellipsis,
              ),
              textColor: _isFinished[index] ? Colors.white30 : Colors.white,
              //tileColor: const Color.fromARGB(255, 234, 211, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              dense: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      widget.onEdit(note);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: _isFinished[index] ? Colors.white30 : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.deleteNote(note);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: _isFinished[index] ? Colors.white30 : Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _isFinished[index] = !_isFinished[index];
                });
              },
            ),
          ),
        );
      },
    );
  }
}
