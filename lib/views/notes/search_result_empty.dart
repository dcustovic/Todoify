import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SearchResultEmpty extends StatelessWidget {
  const SearchResultEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      body: FadeIn(
        duration: const Duration(seconds: 1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Your task list is empty.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(122, 255, 255, 255),
                  ),
                ),
                Text(
                  "Try to create some tasks.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(122, 255, 255, 255),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
