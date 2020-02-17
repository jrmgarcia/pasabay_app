import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/ui/widgets/task_item.dart';
import 'package:pasabay_app/viewmodels/home_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.listenToPosts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Browse"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceSmall,
              Expanded(
                child: model.posts != null ?
                ListView.builder(
                  itemCount: model.posts.length,
                  itemBuilder: (context, index) {
                  return TaskItem(
                      post: model.posts[index],
                    );
                  }
                ) : Center (
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              ),
              verticalSpaceLarge
            ],
          ),
        ),
      )
    );
  }
}
