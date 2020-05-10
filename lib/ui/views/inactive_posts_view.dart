import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/viewmodels/inactive_posts_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class InactivePostsView extends StatelessWidget {
  InactivePostsView({Key key}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InactivePostsViewModel>.withConsumer(
      viewModel: InactivePostsViewModel(),
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
                    final timestamp = DateTime.parse(post.timestamp);
                    final daysAgo = DateTime.now().difference(timestamp).inDays;
                    if (post.fulfilledBy != null || daysAgo > 7) return model.buildItem(context, post);
                    else return SizedBox();
                  }
                ).toList()
              );
            }
          }
        )
      )
    );
  }
}
