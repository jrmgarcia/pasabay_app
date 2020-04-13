import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/category_names.dart';

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

final myTitleStyle2 = TextStyle(
  fontWeight: FontWeight.bold,
  color: Color(0xFF888888),
  fontSize: 26.0,
  height: 1.5,
);

final mySubtitleStyle1 = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

final mySubtitleStyle2 = TextStyle(
  color: Color(0xFF888888),
  fontSize: 18.0,
  height: 1.2,
);

final myBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(blurRadius: 9, color: Colors.grey[200], spreadRadius: 3)
  ]
);

Widget mySnackBar(String message) {
  return SnackBar(
    content: Text(message, style: mySubtitleStyle1),
    backgroundColor: Color(0xFFF6DB7F),
    duration: Duration(milliseconds : 1000),
  );
}

Widget myBackButton(BuildContext context) {
  return IconButton(
    tooltip: 'Back', 
    icon: Icon(FontAwesomeIcons.chevronLeft), 
    onPressed: () => Navigator.of(context).pop()
  );
} 

IconData categoryIcon(String category) {
  switch(category) {
    case Cleaning: 
      return FontAwesomeIcons.broom;
      break;
    case Delivery: 
      return FontAwesomeIcons.shoppingBasket;
      break;
    case Officework: 
      return FontAwesomeIcons.briefcase;
      break;
    case PetSitting: 
      return FontAwesomeIcons.paw;
      break;
    case Schoolwork: 
      return FontAwesomeIcons.appleAlt;
      break;
    default: 
      return FontAwesomeIcons.bug;
  }
}