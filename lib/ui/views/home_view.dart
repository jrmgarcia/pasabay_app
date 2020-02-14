import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/home_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: MyDrawer(),
        body: Center(child: Text('Home Page'),),
      )
    );
  }
}
