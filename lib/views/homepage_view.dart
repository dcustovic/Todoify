import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'notes/create_update_note_view.dart';
import 'notes/notes_view.dart';
import 'profile_view.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final pages = [
    const NotesView(),
    const AddNoteView(),
    const ProfileView(),
  ];
  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 252, 245, 255),
        animationDuration: const Duration(milliseconds: 325),
        height: 60,
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (selectedIndex) {
          setState(() {
            _pageController.animateToPage(
              selectedIndex,
              duration: const Duration(milliseconds: 1),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}

/* Widget getSelectedWidget({required int index}) {
  switch (index) {
    case 0:
      return const NotesView();
    case 1:
      return const AddNoteView();
    case 2:
      return const ProfileView();
  }

  return const CustomLoadingIndicator();
} */
