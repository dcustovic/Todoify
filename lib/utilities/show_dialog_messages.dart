import 'package:flutter/material.dart';

Future<bool> showLogoutMessage(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Sign out",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text(
          "Are you sure you want to sign out?",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 70, 63, 88),
                  fontWeight: FontWeight.w500,
                ),
              )),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 114, 98, 253)),
              ),
              child: const Text(
                "Log out",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      );
    },
    // function returns a bool, but showDialog returns an optional bool
  ).then((value) => value ?? false);
}

Future<void> showErrorMessage(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 114, 98, 253)),
            ),
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showCannotShareEmptyNote(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Warning",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text(
          "Cannot share empty task.",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 114, 98, 253)),
            ),
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool> showDeleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Are you sure?",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text(
          "Are you sure you want to delete this task?",
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 70, 63, 88),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 70, 63, 88),
                  fontWeight: FontWeight.w500,
                ),
              )),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 114, 98, 253)),
              ),
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      );
    },
    // function returns a bool, but showDialog returns an optional bool
  ).then((value) => value ?? false);
}
