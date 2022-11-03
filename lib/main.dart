import 'package:flutter/material.dart';
import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/utilities/loading_indicator.dart';
import 'package:notes_flutter/views/notes/notes_view.dart';

import 'views/homepage_view.dart';
import 'views/login_view.dart';
import 'views/notes/create_update_note_view.dart';
import 'views/registration_view.dart';
import 'views/email_verification_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
      routes: {
        homeRoute: (context) => const HomepageView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const EmailVerificationView(),
        createOrUpdateNoteRoute: (context) => const AddNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user == null) {
              return const LoginView();
            } else {
              if (user.isEmailVerified) {
                return const HomepageView();
              } else {
                return const EmailVerificationView();
              }
            }
          default:
            return const CustomLoadingIndicator();
        }
      },
    );
  }
}
