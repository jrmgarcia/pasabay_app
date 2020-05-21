import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/viewmodels/active_posts_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

int _postCount = 0;
get postCount => _postCount;

class ActivePostsView extends StatelessWidget {
  ActivePostsView({Key key}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    
    return ViewModelProvider<ActivePostsViewModel>.withConsumer(
      viewModel: ActivePostsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: StreamBuilder<List<Post>>(
          stream: _firestoreService.getPostData(_authenticationService.currentUser.uid),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> postsSnapshot) {
            if (postsSnapshot.hasError)
              return Text('Error: ${postsSnapshot.error}');
            switch (postsSnapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
              default:
                _postCount = 0;
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: postsSnapshot.data.map((Post post) {
                    var timestamp = DateTime.parse(post.timestamp);
                    var timeInMinutes = DateTime.now().difference(timestamp).inMinutes;
                    if (post.fulfilledBy == null && timeInMinutes < 10080) {
                      _postCount++;
                      return model.buildItem(post);
                    }
                    else return SizedBox();
                  }
                ).toList()
              );
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          backgroundColor: !model.busy ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          child: !model.busy ? Icon(FontAwesomeIcons.plus, color: Colors.white) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          onPressed: postCount < 5
          ? model.navigateToCreateView
          : model.limitPost,
        ),
      )
    );
  }
}
