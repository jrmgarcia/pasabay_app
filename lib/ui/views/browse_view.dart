import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/ui/widgets/browse_item.dart';
import 'package:pasabay_app/viewmodels/browse_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final RefreshController _refreshController = RefreshController(initialRefresh: false);

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final FirestoreService _firestoreService = locator<FirestoreService>();

User _postUser;
User get postUser => _postUser;

class BrowseView extends StatelessWidget {
  const BrowseView({Key key}) : super(key: key);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BrowseViewModel>.withConsumer(
      viewModel: BrowseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Browse", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(waterDropColor: Theme.of(context).accentColor),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body;
              if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("load failed");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("end of list");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.documents.length > 0) {
                    return Column(
                      children: snapshot.data.documents.map((doc) => 
                        doc.data['userId'] == _authenticationService.currentUser.uid
                        ? SizedBox.shrink()
                        : FutureBuilder(
                            future: Future.wait([getPostUser(doc.data['userId']),]),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () => model.viewPost(doc), 
                                  child: _buildItem(doc, postUser)
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          )
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
        ),
      )
    );
  }
}

Widget _buildItem(DocumentSnapshot doc, User postUser) {
  return BrowseItem(
    post: Post.fromMap(doc.data, doc.documentID),
    user: User(displayName: postUser.displayName, email: postUser.email, photoUrl: postUser.photoUrl, rating: postUser.rating, uid: postUser.uid)
  );
}

Future getPostUser(String uid) async {
  _postUser = await _firestoreService.getUser(uid);
}