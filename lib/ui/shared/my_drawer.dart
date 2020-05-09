import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final NavigationService _navigationService = locator<NavigationService>();
final DialogService _dialogService = locator<DialogService>();

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
            ),
            accountName: Text(_authenticationService.currentUser.displayName ?? ' ', style: TextStyle(color: Colors.white)),
            accountEmail: Text(_authenticationService.currentUser.email ?? ' ', style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                _authenticationService.currentUser.photoUrl ?? 'https://lh3.googleusercontent.com/-cXXaVVq8nMM/AAAAAAAAAAI/AAAAAAAAAKI/_Y1WfBiSnRI/photo.jpg?sz=50',
              ),
              radius: 60,
              backgroundColor: Colors.transparent,
            )
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(FontAwesomeIcons.user),
            onTap: () async {
              await _authenticationService.syncUserProfile(_authenticationService.currentUser.uid);
              await _navigationService.navigateTo(ProfileViewRoute, arguments: _authenticationService.currentUser);
              if (_authenticationService.currentUser.rating < 3) await _dialogService.showDialog(
                title: "Please mind your rating",
                description: "Once you reached an average rate of less than two, the system will automatically ban you from using the application."
              );
            },
            trailing: Icon(FontAwesomeIcons.caretRight),
          ),
          ListTile(
            title: Text("Blacklist"),
            leading: Icon(FontAwesomeIcons.ban),
            onTap: () {
              _navigationService.navigateTo(BlacklistViewRoute);
            },
            trailing: Icon(FontAwesomeIcons.caretRight),
          ),
          ListTile(
            title: Text("Sign out"),
            leading: Icon(FontAwesomeIcons.signOutAlt),
            onTap: () async {
              await _authenticationService.signOutGoogle();
              await _navigationService.navigateTo(LoginViewRoute);
            },
            trailing: Icon(FontAwesomeIcons.caretRight),
          ),
        ],
      ),
    );
  }
}