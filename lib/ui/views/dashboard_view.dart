import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/dashboard_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key key}) : super(key: key);

  Card makeDashboardItem(String title, String fileName, Future Function() function) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: myBoxDecoration,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: function,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Center(
                child: SizedBox(
                  child: Image.asset('assets/images/' + fileName, height: 150),
                )
              ),
              Center(
                child: Text(title, style: TextStyle(fontSize: 14.0, color: Color(0xFF888888))),
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
        body: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Cleaning", "icon_cleaning.PNG", model.browseTo),
            makeDashboardItem("Delivery", "icon_delivery.PNG", model.browseTo),
            makeDashboardItem("Officework", "icon_officework.PNG", model.browseTo),
            makeDashboardItem("Pet Sitting", "icon_pet_sitting.PNG", model.browseTo),
            makeDashboardItem("Schoolwork", "icon_schoolwork.PNG", model.browseTo),
            makeDashboardItem("Post Task", "icon_post_task.PNG", model.navigateToCreateView)
          ],
        ),
      ),
      )
    );
  }
}
