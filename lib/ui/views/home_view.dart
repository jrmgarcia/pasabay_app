import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/widgets/post_item.dart';
import 'package:pasabay_app/viewmodels/home_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.listenToPosts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Pasabay"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: Drawer(
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
                  model.navigateToLoginView();
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceLarge,
              Row(
                children: <Widget>[
                  Text(
                    'Your Posts',
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
              Expanded(
                child: model.posts != null ?
                ListView.builder(
                  itemCount: model.posts.length,
                  itemBuilder: (context, index) => PostItem(
                    post: model.posts[index],
                  ),
                ) : Center (
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).backgroundColor),
                  ),
                )
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
          child: !model.busy ? Icon(Icons.add) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: model.navigateToCreateView,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
