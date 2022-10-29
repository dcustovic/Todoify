import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 81, 223),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SpinKitCircle(
              color: Colors.white,
              size: 45.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Loading',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
