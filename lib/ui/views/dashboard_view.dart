import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/dashboard_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key key}) : super(key: key);

  Card makeDashboardItem(String title, IconData icon, Future Function() function) {
    return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFFF6DB7F)),
        child: new InkWell(
          onTap: function,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: Colors.white,
              )),
              SizedBox(height: 20.0),
              Center(
                child: Text(title, style: TextStyle(fontSize: 18.0, color: Colors.white)),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DashboardViewModel>.withConsumer(
      viewModel: DashboardViewModel(),
      builder: (context, model, child) => Scaffold(
        endDrawer: MyDrawer(),
        body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Cleaning", FontAwesomeIcons.broom, model.browseTo),
            makeDashboardItem("Delivery", FontAwesomeIcons.truck, model.browseTo),
            makeDashboardItem("Officework", FontAwesomeIcons.briefcase, model.browseTo),
            makeDashboardItem("Pet Sitting", FontAwesomeIcons.paw, model.browseTo),
            makeDashboardItem("Schoolwork", FontAwesomeIcons.graduationCap, model.browseTo),
            makeDashboardItem("Post Task", FontAwesomeIcons.plusCircle, model.navigateToCreateView)
          ],
        ),
      ),
      )
    );
  }
}
