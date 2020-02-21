import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/posts_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();

class PostsView extends StatelessWidget {
  const PostsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PostsViewModel>.withConsumer(
      viewModel: PostsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: ListView(
        padding: EdgeInsets.all(8),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('posts')
                .where('userId', isEqualTo: _authenticationService.currentUser.uid.toString())
                .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) => 
                      GestureDetector(
                        onTap: () => model.updatePost(doc), 
                        child: model.buildItem(doc)
                      )
                    ).toList()
                  );
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          child: !model.busy ? Icon(Icons.add, color: Colors.white) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: model.navigateToCreateView,
        ),
      )
    );
  }
}
