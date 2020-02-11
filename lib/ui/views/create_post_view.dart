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
        floatingActionButton: FloatingActionButton(
          child: !model.busy ? Icon(Icons.add) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: () {
            if (!model.busy) {
              model.addPost(title: titleController.text);
            }
          },
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceLarge,
              Text(
                'Create Post',
                style: TextStyle(fontSize: 26),
              ),
              verticalSpaceMedium,
              InputField(
                placeholder: 'Title',
                controller: titleController,
              ),
              verticalSpaceMedium,
              Text('Post Image'),
              verticalSpaceSmall,
              Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text(
                  'Tap to add post image',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
