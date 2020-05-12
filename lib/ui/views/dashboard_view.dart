import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/dashboard_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key key}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  Widget makeDashboardItem(BuildContext context, String title, String fileName, Future Function() function) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(8),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: function,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: SizedBox(
                child: Image.asset('assets/images/' + fileName),
              )
            ),
            Flexible(
              flex: 1,
              child: Text(title, style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DashboardViewModel>.withConsumer(
      viewModel: DashboardViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white60, width: 2.0)
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_authenticationService.currentUser.photoUrl),
                          ),
                        )
                      ]
                    ),
                    verticalSpaceSmall,
                    Text(_authenticationService.currentUser.displayName, style: Theme.of(context).textTheme.headline5.apply(color: Colors.white)),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("What do you want to do today?", style: Theme.of(context).textTheme.subtitle2),
                      )
                    )
                  ]
                )
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.5),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
                ),
                child: Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      makeDashboardItem(context, Cleaning, "icon_cleaning.PNG", model.browseCleaning),
                      makeDashboardItem(context, Delivery, "icon_delivery.PNG", model.browseDelivery),
                      makeDashboardItem(context, Officework, "icon_officework.PNG", model.browseOfficework),
                      makeDashboardItem(context, PetSitting, "icon_pet_sitting.PNG", model.browsePetSitting),
                      makeDashboardItem(context, Schoolwork, "icon_schoolwork.PNG", model.browseToSchoolwork),
                      makeDashboardItem(context, "Post Task", "icon_post_task.PNG", model.navigateToCreateView)
                    ],
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}

