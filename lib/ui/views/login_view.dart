import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pasabay_app/viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: SizedBox(
                  child: Image.asset('assets/images/pasabay_logo.png'),
                ),
              ),
              Flexible(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(queryData.size.width/8),
                  child: SizedBox(
                    child: Image.asset('assets/images/pasabay_icon.png'),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    model.signIn();
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                          child: Image.asset('assets/images/google_logo.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: Theme.of(context).textTheme.subtitle2.apply(color: Color(0xFF888888)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("By signing in, you agree to our ", style: TextStyle(color: Colors.white)),
                          InkWell(
                            child: Text("Privacy Policy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            onTap: () => _navigationService.navigateTo(PrivacyPolicyViewRoute))
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("and our ", style: TextStyle(color: Colors.white)),
                          InkWell(
                            child: Text("Terms & Conditons", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)), 
                            onTap: () => _navigationService.navigateTo(TermsConditionsViewRoute)
                          )
                        ]
                      )
                    ]
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}