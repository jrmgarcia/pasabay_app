import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/widgets/browse_item.dart';
import 'package:pasabay_app/viewmodels/browse_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:shimmer/shimmer.dart';

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

User _postUser;
User get postUser => _postUser;

class BrowseView extends StatelessWidget {
  final String browsingCategory;
  const BrowseView({Key key, this.browsingCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BrowseViewModel>.withConsumer(
      viewModel: BrowseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Browse", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('posts')
                .where('category', isEqualTo: browsingCategory)
                .orderBy('timestamp', descending: true)
                .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return Column(
                    children: snapshot.data.documents.map((doc) => 
                      doc.data['userId'] != _authenticationService.currentUser.uid
                      ? FutureBuilder(
                          future: Future.wait([getPostUser(doc.data['userId']),]),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                              return InkWell(
                                onTap: () => model.viewPost(doc), 
                                child: _buildItem(doc, postUser)
                              );
                            } else {
                              return Container(
                                height: 80,
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                alignment: Alignment.center,
                                decoration: myBoxDecoration(context),
                                child: ListTile(
                                  leading: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10), 
                                      child: SizedBox(
                                        width: 50, 
                                        height: 50, 
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(color: Colors.grey[200])
                                        )
                                      )
                                    ),
                                  ),
                                  title: Shimmer.fromColors(
                                    baseColor: Theme.of(context).scaffoldBackgroundColor,
                                    highlightColor: Theme.of(context).cardColor,
                                    child: SizedBox(
                                      height: 26, 
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor)
                                      )
                                    )
                                  ),
                                  subtitle: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: SizedBox(
                                      height: 16, 
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: Colors.grey[200])
                                      )
                                    )
                                  ),
                                )
                              );
                            }
                          }
                        )
                      : SizedBox.shrink()
                    ).toList()
                  );
                } else {
                  return Column(children: <Widget>[
                    SizedBox(height: 256), 
                    Text('No posts yet!')
                  ]);
                }
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Search',
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(FontAwesomeIcons.search, color: Colors.white),
          onPressed: model.navigateToSearchView,
        ),
      )
    );
  }
}

Widget _buildItem(DocumentSnapshot doc, User postUser) {
  return BrowseItem(
    post: Post.fromMap(doc.data, doc.documentID),
    user: User(
      displayName: postUser.displayName, 
      email: postUser.email, 
      photoUrl: postUser.photoUrl, 
      rating: postUser.rating, 
      uid: postUser.uid
    )
  );
}

Future getPostUser(String uid) async {
  _postUser = await _firestoreService.getUser(uid);
}