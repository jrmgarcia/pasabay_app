import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/services/authentication_service.dart';
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

// Custome Widgets
myBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(10),
  );
}

Widget mySnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.subtitle1.apply(color: Colors.white)),
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
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 80,
      margin: EdgeInsets.all(8.0),
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
    ),
  );
}

Widget userPhotoUrl(String photoUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        ),
        width: 50.0,
        height: 50.0,
        padding: EdgeInsets.all(15.0),
      ),
      imageUrl: photoUrl,
      width: 50.0,
      height: 50.0,
      fit: BoxFit.cover,
    ),
  );
}

final AuthenticationService _authenticationService = locator<AuthenticationService>();

peerUser(Task task) {
  if (task.userId == _authenticationService.currentUser.uid) {
    return task.doerName.substring(0, task.doerName.indexOf(' ')) + " " + task.doerRating.toStringAsFixed(2) + " ★";
  } else return task.userName.substring(0, task.userName.indexOf(' ')) + " " + task.userRating.toStringAsFixed(2) + " ★";
}