import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:shimmer/shimmer.dart';

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
final myTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontSize: 26.0,
  height: 1.5,
);

final mySubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

myBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(10),
  );
}

Widget mySnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.subhead.apply(color: Colors.white)),
    backgroundColor: Theme.of(context).accentColor,
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

final myGradient = [Color(0xFFFDA085), Color(0xFFF6D365)];

shimmerEffect(Brightness brightness, double height, [double width]) {
  return Shimmer.fromColors(
    baseColor: brightness == Brightness.dark ? Colors.black45 : Colors.grey[300],
    highlightColor: brightness == Brightness.dark ? Colors.black : Colors.grey[100],
    child: SizedBox(
      height: height, 
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(color: brightness == Brightness.dark ? Colors.black38 : Colors.grey[200])
      )
    )
  );
}

shimmerCard(BuildContext context) {
  return Container(
    height: 80,
    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
    alignment: Alignment.center,
    decoration: myBoxDecoration(context),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: shimmerEffect(MediaQuery.of(context).platformBrightness, 50, 50)
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 2),
        child: shimmerEffect(MediaQuery.of(context).platformBrightness, 26)
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 6),
        child: shimmerEffect(MediaQuery.of(context).platformBrightness, 16)
      ),
    )
  );
}