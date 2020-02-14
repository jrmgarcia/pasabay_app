import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/ui/widgets/input_field.dart';
import 'package:pasabay_app/viewmodels/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreatePostView extends StatelessWidget {
  final titleController = TextEditingController();
  final Post editingPost;
  CreatePostView({Key key, this.editingPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CreatePostViewModel>.withConsumer(
      viewModel: CreatePostViewModel(),
      onModelReady: (model) {
        // update the text in the controller
        titleController.text = editingPost?.title ?? '';

        model.setEditingPost(editingPost);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Create a Post"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceMedium,
              Text('Post Information'),
              verticalSpaceSmall,
              InputField(
                placeholder: 'Title',
                controller: titleController,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: !model.busy ? Icon(Icons.add, color: Colors.white,) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: () {
            if (!model.busy) {
              model.addPost(title: titleController.text);
            }
          },
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
