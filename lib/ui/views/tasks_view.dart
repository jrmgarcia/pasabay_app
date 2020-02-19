import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/tasks_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TasksViewModel>.withConsumer(
      viewModel: TasksViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Tasks", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        endDrawer: MyDrawer(),
        body: Center(child: Text('Tasks Page'),),
      )
    );
  }
}
