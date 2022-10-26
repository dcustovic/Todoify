import 'package:flutter/material.dart';

import '../../constants/routes.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        backgroundColor: const Color.fromARGB(255, 95, 81, 223),
        automaticallyImplyLeading: false,
      ),
      body: const Text("Write new note here..."),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: const Color.fromARGB(255, 95, 81, 223),
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 28,
              ),
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: const Color.fromARGB(255, 17, 199, 0),
            onPressed: () {},
            child: const Icon(
              Icons.check,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
