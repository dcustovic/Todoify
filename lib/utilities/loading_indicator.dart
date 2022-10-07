import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 214, 214, 214),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Loading'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
