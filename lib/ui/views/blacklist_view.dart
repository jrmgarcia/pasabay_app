import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/blacklist_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class BlacklistView extends StatelessWidget {
  const BlacklistView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BlacklistViewModel>.withConsumer(
      viewModel: BlacklistViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Blacklist", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        endDrawer: MyDrawer(),
        body: Center(child: Text('Blacklist Page'),),
      )
    );
  }
}
