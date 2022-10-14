import 'package:flutter/material.dart';
import 'package:notes_flutter/constants/routes.dart';
import 'package:notes_flutter/services/auth/auth_service.dart';
import 'package:notes_flutter/utilities/loading_indicator.dart';
import 'package:notes_flutter/views/notes_view.dart';

import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/email_verification_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const EmailVerificationView(),
      }));
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
                return const NotesView();
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
