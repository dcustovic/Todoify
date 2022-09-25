import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email = TextEditingController();
    password = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyApp')),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(
              hintText: "Enter email")),
          TextField(
            controller: password,
            decoration: const InputDecoration(
              hintText: "Enter password")),
          TextButton(
            onPressed: () => {}, 
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}