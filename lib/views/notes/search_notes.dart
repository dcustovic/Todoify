import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({super.key});

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const TextField(
        decoration: InputDecoration(
          hintText: "Search a task...",
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
