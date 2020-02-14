import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/widgets/post_item.dart';
import 'package:pasabay_app/viewmodels/posts_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class PostsView extends StatelessWidget {
  const PostsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PostsViewModel>.withConsumer(
      viewModel: PostsViewModel(),
      onModelReady: (model) => model.listenToPosts(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Posts"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        endDrawer: MyDrawer(),
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
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => model.editPost(index),
                    child: PostItem(
                      post: model.posts[index],
                      onDeleteItem: () => model.deletePost(index),
                    ),
                  )
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
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          child: !model.busy ? Icon(Icons.add, color: Colors.white) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: model.navigateToCreateView,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
