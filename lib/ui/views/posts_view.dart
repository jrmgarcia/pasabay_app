import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/viewmodels/posts_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class PostsView extends StatelessWidget {
  PostsView({Key key}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PostsViewModel>.withConsumer(
      viewModel: PostsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: StreamBuilder<List<Post>>(
          stream: _firestoreService.getPostData(_authenticationService.currentUser.uid),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> postsSnapshot) {
            if (postsSnapshot.hasError)
              return Text('Error: ${postsSnapshot.error}');
            switch (postsSnapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: postsSnapshot.data.map((Post post) {
                    return model.buildItem(post);
                  }
                ).toList()
              );
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add post',
          elevation: 0,
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          child: !model.busy ? Icon(FontAwesomeIcons.plus, color: Colors.white) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: model.navigateToCreateView,
        ),
      )
    );
  }
}
