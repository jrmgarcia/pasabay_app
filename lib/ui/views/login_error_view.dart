import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

NavigationService _navigationService = locator<NavigationService>();

class LoginErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: myGradient
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: SizedBox(
                child: Image.asset('assets/images/pasabay_logo.png'),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Login Failed", style: Theme.of(context).textTheme.headline6.apply(color: Colors.white)),
              )
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("You can't log in to Pasabay using this account due to one of the following restrictions:", style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.white)),
                    ListTile(leading: Icon(FontAwesomeIcons.at, color: Colors.white), title: Text("It's not a UP Mail account (@up.edu.ph)", style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white))),
                    ListTile(leading: Icon(FontAwesomeIcons.star, color: Colors.white), title: Text("You've reached an avarage rating of less than 2 stars.", style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white)))
                  ]
                ),
              )
            ),
            Flexible(
              flex: 1,
              child: RaisedButton(
                onPressed: () {
                  _navigationService.navigateTo(LoginViewRoute);
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    'Understood',
                    style: Theme.of(context).textTheme.subtitle2.apply(color: Color(0xFF888888)),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}