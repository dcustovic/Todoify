import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/cloud_storage_firebase.dart';
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
  late final CloudStorageFirebase _notesService;

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
  }

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
              color: note.completed == false
                  ? const Color.fromARGB(94, 29, 8, 63)
                  : const Color.fromARGB(152, 39, 39, 39),
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
                    key: ValueKey(note.documentId),
                    startActionPane: startActionPane(note, widget),
                    endActionPane: endActionPane(context, note, widget),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 0.15),
                      contentPadding:
                          const EdgeInsets.only(left: 12, right: 12),
                      title: Text(
                        note.text,
                        style: note.completed == false
                            ? null
                            : const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                        //maxLines: 1,
                        //softWrap: true,
                        //overflow: TextOverflow.ellipsis,
                      ),
                      textColor: note.completed == false
                          ? Colors.white
                          : Colors.white38,
                      //tileColor: const Color.fromARGB(255, 234, 211, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dense: true,
                      onTap: () async {
                        await _notesService.updateNote(
                          documentId: note.documentId,
                          text: note.text,
                          completed: !note.completed,
                        );
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
            const Color.fromARGB(235, 255, 153, 0),
          );
        }),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        backgroundColor: const Color.fromARGB(235, 255, 153, 0),
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
            const Color.fromARGB(235, 33, 149, 243),
          );
        },
        backgroundColor: const Color.fromARGB(235, 33, 149, 243),
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
    motion: const StretchMotion(),
    dismissible: DismissiblePane(
      onDismissed: () {
        widget.deleteNote(note);
        showSnackBar(
          context,
          "Task has been successfully deleted.",
          const Color.fromARGB(235, 244, 67, 54),
        );
      },
    ),
    children: const [
      SlidableAction(
        // An action can be bigger than the others.
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        onPressed: null,
        backgroundColor: Color.fromARGB(235, 244, 67, 54),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Swipe to delete',
      ),
    ],
  );
}
