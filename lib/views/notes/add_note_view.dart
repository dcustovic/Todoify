import 'package:flutter/material.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
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
      body: const Text(
        "Write new note here...",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
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
