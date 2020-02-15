import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pasabay_app/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]
            )
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image.asset('assets/images/pasabay_logo.png', color: Colors.white),
                ),
                verticalSpaceLarge,
                SizedBox(
                  child: Image.asset('assets/images/pasabay_icon.png'),
                ),
                verticalSpaceLarge,
                RaisedButton(
                  splashColor: Theme.of(context).accentColor,
                  onPressed: () {
                    model.signIn();
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          child: Image.asset('assets/images/google_logo.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}