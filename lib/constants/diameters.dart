import 'package:flutter/material.dart';

double getSmallDiameter(BuildContext context) =>
    MediaQuery.of(context).size.width * 2 / 3;
double getBiglDiameter(BuildContext context) =>
    MediaQuery.of(context).size.width * 7 / 8;
