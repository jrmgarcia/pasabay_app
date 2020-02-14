import 'package:pasabay_app/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/pasabay_logo.png', color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                strokeWidth: 3, 
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).accentColor
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}