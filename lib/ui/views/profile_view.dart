import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/profile_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileViewModel>.withConsumer(
      viewModel: ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        endDrawer: MyDrawer(),
        body: Center(child: Text('Profile Page'),),
      )
    );
  }
}
