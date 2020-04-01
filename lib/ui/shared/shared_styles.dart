import 'package:flutter/material.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle =
    const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

// Text Styles
final myTitleStyle1 = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 26.0,
  height: 1.5,
);

final mySubtitleStyle1 = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

final myBoxDecoration = BoxDecoration(
  color: Color(0xFFF6DB7F),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
  ]
);