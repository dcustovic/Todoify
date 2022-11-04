import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var x = 0.0;
    var numberOfWaves = 1;
    var increment = size.width / numberOfWaves;
    bool startFromTop = false;

    while (x < size.width) {
      if (startFromTop) {
        path.lineTo(x, 42);
        path.cubicTo(x + increment / 2, 0, x + increment / 2, size.height,
            x + increment, size.height);
      } else {
        path.lineTo(x, size.height);
        path.cubicTo(x + increment / 2, size.height, x + increment / 2, 0,
            x + increment, 42);
      }
      x += increment;
      startFromTop = !startFromTop;
    }

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
