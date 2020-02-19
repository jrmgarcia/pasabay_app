import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final NavigationService _navigationService = locator<NavigationService>();

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
            title: Text("Profile", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
            onTap: () {
              _navigationService.navigateTo(ProfileViewRoute);
            },
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).primaryColor),
          ),
          ListTile(
            title: Text("Posts", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.list, color: Theme.of(context).primaryColor),
            onTap: () {
              _navigationService.navigateTo(PostsViewRoute);
            },
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).primaryColor),
          ),
          ListTile(
            title: Text("Tasks", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.directions_run, color: Theme.of(context).primaryColor),
            onTap: () {
              _navigationService.navigateTo(TasksViewRoute);
            },
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).primaryColor),
          ),
          ListTile(
            title: Text("Blacklist", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.block, color: Theme.of(context).primaryColor),
            onTap: () {
              _navigationService.navigateTo(BlacklistViewRoute);
            },
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).primaryColor),
          ),
          ListTile(
            title: Text("Sign out", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
            onTap: () {
              _authenticationService.signOutGoogle();
              _navigationService.navigateTo(LoginViewRoute);
            },
            trailing: Icon(Icons.arrow_right, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}