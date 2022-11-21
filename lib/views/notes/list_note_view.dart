import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/cloud/cloud_note.dart';

typedef NoteCallback = void Function(CloudNote note);

class ListNoteView extends StatefulWidget {
  final Iterable<CloudNote> notes;
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
      padding: const EdgeInsets.only(left: 15, right: 15),
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes.elementAt(index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PhysicalShape(
            color: _isFinished[index]
                //const Color.fromARGB(108, 28, 0, 66)
                ? const Color.fromARGB(152, 39, 39, 39)
                : const Color.fromARGB(94, 29, 8, 63),
            elevation: 1,
            shadowColor: const Color.fromARGB(34, 33, 0, 87),
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 12, right: 0),
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
              textColor: _isFinished[index] ? Colors.white38 : Colors.white,
              //tileColor: const Color.fromARGB(255, 234, 211, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              dense: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _isFinished[index]
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            widget.onEdit(note);
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      widget.deleteNote(note);
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: _isFinished[index] ? Colors.white38 : Colors.white,
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
