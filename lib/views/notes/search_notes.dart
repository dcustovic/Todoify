import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:notes_flutter/views/notes/search_result_empty.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/cloud_storage_firebase.dart';
import '../../utilities/show_snackbar.dart';

class SearchNotes extends StatefulWidget {
  final Iterable<CloudNote> notes;
  final String searchResult;

  const SearchNotes({
    super.key,
    required this.notes,
    required this.searchResult,
  });

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  late final CloudStorageFirebase _notesService;

  @override
  void initState() {
    super.initState();
    _notesService = CloudStorageFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 15, right: 15),
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            final note = widget.notes.elementAt(index);

            String formattedDateNote =
                DateFormat('dd-MM-yyyy').format(note.date!.toDate());

            if (widget.searchResult == '') {
              return Container();
            }

            if (note.text.contains(widget.searchResult) ||
                note.description!.contains(widget.searchResult)) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: PhysicalShape(
                  color: note.completed == false
                      ? const Color.fromARGB(94, 29, 8, 63)
                      : const Color.fromARGB(152, 39, 39, 39),
                  elevation: 10,
                  shadowColor: const Color.fromARGB(108, 27, 0, 71),
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
                          contentPadding: const EdgeInsets.only(
                              left: 15, right: 15, top: 13, bottom: 10),
                          title: Text(
                            note.text,
                            style: note.completed == false
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )
                                : const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            //maxLines: 1,
                            //softWrap: true,
                            //overflow: TextOverflow.ellipsis,
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.5),
                                child: Text(
                                  note.description!,
                                  style: note.completed == false
                                      ? const TextStyle(fontSize: 12.5)
                                      : const TextStyle(
                                          fontSize: 12.5,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 11, right: 4),
                                        child: Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.deepOrange,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: formattedDateNote,
                                      style: note.completed == false
                                          ? const TextStyle(fontSize: 12.5)
                                          : const TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.white38,
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
                              description: note.description,
                              date: note.date,
                              completed: !note.completed!,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

ActionPane startActionPane(CloudNote note, widget) {
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
          final title = note.text;
          final description = note.description;
          final date = DateFormat('dd-MM-yyyy').format(note.date!.toDate());
          Share.share(
              'Title: $title\n\nDescription: $description\n\nDate: $date');
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

ActionPane endActionPane(BuildContext context, CloudNote note, widget) {
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
