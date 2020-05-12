import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/ui/widgets/expansion_list.dart';
import 'package:pasabay_app/ui/widgets/input_field.dart';
import 'package:pasabay_app/viewmodels/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:intl/intl.dart';

class CreatePostView extends StatelessWidget {
  
  final Post editingPost;
  CreatePostView({Key key, this.editingPost}) : super(key: key);

  final titleController = TextEditingController();
  final rewardController = TextEditingController();
  final descriptionController = TextEditingController();

  final focusDescription = FocusNode();
  final focusReward = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var expirationDate = DateFormat('E, MMM dd K:mm a').format(DateTime.now().add(Duration(days: 7)));
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
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: editingPost != null ? Text("Edit a Post", style: TextStyle(color: Colors.white)) : Text("Create a Post", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              ExpansionList<String>(
                items: ['Cleaning', 'Delivery', 'Officework', 'Pet Sitting', 'Schoolwork'],
                title: model.selectedCategory,
                onItemSelected: model.setSelectedCategory,
              ),
              verticalSpaceTiny,
              InputField(
                autoFocus: true,
                placeholder: 'Title',
                controller: titleController,
                formatter: [
                  LengthLimitingTextInputFormatter(40),
                  BlacklistingTextInputFormatter.singleLineFormatter
                ],
                nextFocusNode: focusReward,
              ),
              InputField(
                fieldFocusNode: focusReward,
                placeholder: 'Reward',
                controller: rewardController,
                textInputType: TextInputType.number,
                formatter: [
                  LengthLimitingTextInputFormatter(6),
                  WhitelistingTextInputFormatter.digitsOnly,
                  BlacklistingTextInputFormatter.singleLineFormatter,
                ],
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
                formatter: [
                  LengthLimitingTextInputFormatter(1000)
                ],
              ),
              Text("*This post will expire on $expirationDate.", style: Theme.of(context).textTheme.overline)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: !model.busy ? Icon(editingPost != null ? FontAwesomeIcons.edit : FontAwesomeIcons.check, color: Colors.white,) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: () {
            if (!model.busy && model.selectedCategory != 'Select Category' && titleController.text.isNotEmpty && rewardController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
              model.addPost(title: titleController.text, reward: rewardController.text, description: descriptionController.text);
            } else {
              if (model.selectedCategory == 'Select Category') {
                _scaffoldKey.currentState.showSnackBar(mySnackBar(context, 'Please select a category.')); 
              } else if (titleController.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(mySnackBar(context, 'Please enter a title.')); 
              } else if (rewardController.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(mySnackBar(context, 'Please enter a reward.')); 
              } else if (descriptionController.text.isEmpty) {
                _scaffoldKey.currentState.showSnackBar(mySnackBar(context, 'Please enter a description.')); 
              } 
            }
          },
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
