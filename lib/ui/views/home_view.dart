import 'package:pasabay_app/ui/shared/app_colors.dart';
import 'package:pasabay_app/ui/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/locator.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomeView()
    );
  }
}

class MyHomeView extends StatefulWidget {
  MyHomeView({Key key}) : super(key: key);

  @override
  _MyHomeViewState createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  int _count = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pasabay"),
        backgroundColor: myColor[2],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: myColor[2],
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
            ),
            ListTile(
              title: Text("Listing"),
            ),
            ListTile(
              title: Text("Inbox"),
            ),
            ListTile(
              title: Text("Blacklist"),
            ),
            ListTile(
              title: Text("Sign out"),
              onTap: () {
                _authenticationService.signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginView();}), ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('You have pressed the button $_count times.'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: myColor[2],
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: myColor[2],
        onPressed: () => setState(() {
          _count++;
        }),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}