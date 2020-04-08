import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/profile_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ProfileView extends StatelessWidget {
  final User viewingUser;
  const ProfileView({Key key, this.viewingUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profile = Container(
      margin: EdgeInsets.all(8),
      width : double.infinity,
      decoration: myBoxDecoration,
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
            style: myTitleStyle2,
          ),
          RatingBarIndicator(
              rating: viewingUser.rating,
              itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
              ),
              itemCount: 5,
              itemSize: 60.0,
              direction: Axis.horizontal,
          ),
          Text(
            viewingUser.rating.toString(),
            style: mySubtitleStyle2,
          ),
          verticalSpaceMedium
        ]
      ),
    );

    return ViewModelProvider<ProfileViewModel>.withConsumer(
      viewModel: ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        endDrawer: MyDrawer(),
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
                  decoration: myBoxDecoration,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Theme.of(context).accentColor,
                    ),
                    title:Text(
                      viewingUser.email,
                      style: mySubtitleStyle2,
                    ),
                  ),
                ),
                onTap: () {
                  // _launchURL('mailto:smith@example.org?subject=News&body=New%20plugin');
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _launchURL(var url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }