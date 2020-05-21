import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/profile_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ProfileView extends StatelessWidget {
  final User viewingUser;
  ProfileView({Key key, this.viewingUser}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    var profile = Container(
      margin: EdgeInsets.all(8),
      width : double.infinity,
      decoration: myBoxDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          verticalSpaceMedium,
          CircleAvatar(
            backgroundImage: NetworkImage(
              viewingUser.photoUrl ?? 'https://lh3.googleusercontent.com/-cXXaVVq8nMM/AAAAAAAAAAI/AAAAAAAAAKI/_Y1WfBiSnRI/photo.jpg?sz=50',
            ),
            radius: 60,
            backgroundColor: Colors.transparent,
          ),
          verticalSpaceSmall,
          Text(
            viewingUser.displayName,
            style: Theme.of(context).textTheme.headline5,
            overflow: TextOverflow.ellipsis
          ),
          RatingBarIndicator(
              rating: viewingUser.rating,
              itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
              ),
              itemCount: 5,
              itemSize: 50.0
          ),
          Text(
            viewingUser.rating.toStringAsFixed(2),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          verticalSpaceMedium
        ]
      ),
    );

    return ViewModelProvider<ProfileViewModel>.withConsumer(
      viewModel: ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        drawer: MyDrawer(),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: profile,
                onTap: () {}
              ),
              InkWell(
                child: Container(
                  decoration: myBoxDecoration(context),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      color: Theme.of(context).accentColor,
                    ),
                    title:Text(
                      viewingUser.email,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                onTap: () {}
              )
            ],
          ),
        ),
        floatingActionButton: _getFloatingActionButton(model, context),
      ),
    );
  }

  Widget _getFloatingActionButton(ProfileViewModel model, BuildContext context) {
    if (_authenticationService.currentUser.uid == viewingUser.uid) {
      return Container();
    } else {
      return FloatingActionButton(
        tooltip: 'Block',
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(FontAwesomeIcons.ban, color: Colors.white),
        onPressed: () {
          model.block(blockedUser: viewingUser.uid, blockedBy: _authenticationService.currentUser.uid);
        }
      );
    }
  }
}