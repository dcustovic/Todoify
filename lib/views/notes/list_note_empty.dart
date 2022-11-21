import 'package:flutter/material.dart';

class ListNoteEmpty extends StatelessWidget {
  const ListNoteEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/list-empty-image.png',
                width: 230,
              ),
              const Text(
                "Oh no!",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(122, 255, 255, 255),
                ),
              ),
              const Text(
                "It appears your to-do list is empty",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(122, 255, 255, 255),
                ),
              ),
              const Text(
                "Swipe left to create one",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(122, 255, 255, 255),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
