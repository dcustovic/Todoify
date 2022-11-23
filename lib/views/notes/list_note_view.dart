import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/cloud/cloud_note.dart';
import '../../utilities/show_snackbar.dart';

typedef NoteCallback = void Function(CloudNote note);

enum Actions { edit, share, delete }

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

        return FadeIn(
          duration: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PhysicalShape(
              color: _isFinished[index]
                  //const Color.fromARGB(108, 28, 0, 66)
                  ? const Color.fromARGB(152, 39, 39, 39)
                  : const Color.fromARGB(94, 29, 8, 63),
              elevation: 1,
              shadowColor: const Color.fromARGB(38, 33, 0, 87),
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SlidableAutoCloseBehavior(
                  child: Slidable(
                    key: ValueKey(note),
                    startActionPane: startActionPane(note, widget),
                    endActionPane: endActionPane(context, note, widget),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 0.15),
                      contentPadding:
                          const EdgeInsets.only(left: 12, right: 12),
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
                      textColor:
                          _isFinished[index] ? Colors.white38 : Colors.white,
                      //tileColor: const Color.fromARGB(255, 234, 211, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dense: true,
                      onTap: () {
                        setState(() {
                          _isFinished[index] = !_isFinished[index];
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

ActionPane startActionPane(CloudNote note, ListNoteView widget) {
  return ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const StretchMotion(),
    children: [
      SlidableAction(
        onPressed: ((context) {
          widget.onEdit(note);
          showSnackBar(
            context,
            "You are editing this task.",
            Colors.orange,
          );
        }),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: Icons.edit,
      ),
      SlidableAction(
        onPressed: (context) {
          final text = note.text;
          Share.share('Todoify app: $text');
          showSnackBar(
            context,
            "Choose an option to share your task.",
            Colors.blue,
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.share,
      ),
    ],
  );
}

ActionPane endActionPane(
    BuildContext context, CloudNote note, ListNoteView widget) {
  return ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const ScrollMotion(),
    dismissible: DismissiblePane(
      onDismissed: () {
        widget.deleteNote(note);
        showSnackBar(
          context,
          "Task has been succesfully deleted.",
          Colors.red,
        );
      },
    ),
    children: [
      SlidableAction(
        key: ValueKey(note),
        // An action can be bigger than the others.
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        onPressed: null,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        //label: 'Swipe all the way',
      ),
    ],
  );
}
