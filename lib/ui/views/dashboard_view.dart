import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/viewmodels/dashboard_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key key}) : super(key: key);

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
              child: Text(title, style: Theme.of(context).textTheme.subtitle, textAlign: TextAlign.center),
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
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
        child: GridView.count(
          crossAxisCount: 2,
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
    );
  }
}
