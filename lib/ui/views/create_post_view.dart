import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/ui/widgets/expansion_list.dart';
import 'package:pasabay_app/ui/widgets/input_field.dart';
import 'package:pasabay_app/viewmodels/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CreatePostView extends StatelessWidget {
  
  final Post editingPost;
  CreatePostView({Key key, this.editingPost}) : super(key: key);

  final titleController = TextEditingController();
  final rewardController = TextEditingController();
  final descriptionController = TextEditingController();

  final focusDescription = FocusNode();
  final focusReward = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CreatePostViewModel>.withConsumer(
      viewModel: CreatePostViewModel(),
      onModelReady: (model) {
        // update the text in the controller
        titleController.text = editingPost?.title ?? '';
        rewardController.text = editingPost?.reward ?? '';
        descriptionController.text = editingPost?.description ?? '';

        model.setEditingPost(editingPost);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: editingPost != null ? Text("Edit a Post") : Text("Create a Post"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              InputField(
                placeholder: 'Title',
                controller: titleController,
                autoFocus: true,
                nextFocusNode: focusReward,
              ),
              InputField(
                fieldFocusNode: focusReward,
                placeholder: 'Reward',
                controller: rewardController,
                textInputType: TextInputType.number,
                nextFocusNode: focusDescription,
              ),
              InputField(
                fieldFocusNode: focusDescription,
                placeholder: 'Description',
                controller: descriptionController,
                textInputType: TextInputType.multiline,
                maxLines: null,
                largeVersion: true,
                textInputAction: TextInputAction.newline,
              ),
              ExpansionList<String>(
                items: ['Cleaning', 'Delivery', 'Officework', 'Pet Sitting', 'Schoolwork'],
                title: model.selectedCategory,
                onItemSelected: model.setSelectedCategory,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: !model.busy ? Icon(editingPost != null ? Icons.edit : Icons.arrow_forward, color: Colors.white,) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: () {
            if (!model.busy) {
              model.addPost(title: titleController.text, reward: rewardController.text, description: descriptionController.text);
            }
          },
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
