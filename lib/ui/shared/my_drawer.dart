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
            accountName: Text(_authenticationService.currentUser.displayName ?? ' '),
            accountEmail: Text(_authenticationService.currentUser.email ?? ' '),
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
            leading: Icon(Icons.account_circle),
            onTap: () {
              _navigationService.navigateTo(ProfileViewRoute);
            },
          ),
          ListTile(
            title: Text("Posts"),
            leading: Icon(Icons.list),
            onTap: () {
              _navigationService.navigateTo(PostsViewRoute);
            },
          ),
          ListTile(
            title: Text("Tasks"),
            leading: Icon(Icons.directions_run),
            onTap: () {
              _navigationService.navigateTo(TasksViewRoute);
            },
          ),
          ListTile(
            title: Text("Blacklist"),
            leading: Icon(Icons.block),
            onTap: () {
              _navigationService.navigateTo(BlacklistViewRoute);
            },
          ),
          ListTile(
            title: Text("Sign out"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              _authenticationService.signOutGoogle();
              _navigationService.navigateTo(LoginViewRoute);
            },
          ),
        ],
      ),
    );
  }
}