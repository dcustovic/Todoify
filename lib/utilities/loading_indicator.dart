import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            SpinKitFoldingCube(
              color: Color.fromARGB(255, 114, 98, 253),
              size: 45.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Loading'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
