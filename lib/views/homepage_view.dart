import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../utilities/loading_indicator.dart';
import 'notes/add_note_view.dart';
import 'notes/notes_view.dart';
import 'profile_view.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 252, 245, 255),
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        index: index,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
      ),
      body: Container(
        child: getSelectedWidget(index: index),
      ),
    );
  }
}

Widget getSelectedWidget({required int index}) {
  switch (index) {
    case 0:
      return const NotesView();
    case 1:
      return const AddNoteView();
    case 2:
      return const ProfileView();
  }

  return const CustomLoadingIndicator();
}
