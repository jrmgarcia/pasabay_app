import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/viewmodels/chat_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

final FirestoreService _firestoreService = locator<FirestoreService>();

Post _post;
Post get post => _post;

User _postUser;
User get postUser => _postUser;

class ChatView extends StatelessWidget {
  const ChatView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChatViewModel>.withConsumer(
      viewModel: ChatViewModel(),
      builder: (context, model, child) => Scaffold(
        body: ListView(
        padding: EdgeInsets.all(8),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('chats')
                .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return Column(
                    children: snapshot.data.documents.map((doc) => 
                      FutureBuilder(
                        future: Future.wait([getPostData(doc.data['userId'], doc.data['postId']),]),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return InkWell(
                              child: model.buildItem(context, post, postUser)
                            );
                          } else {
                              return shimmerCard(context);
                            }
                          }
                        )
                    ).toList()
                  );
                } else {
                  return Column(children: <Widget>[
                    SizedBox(height: 256), 
                    Text('No user found.')
                  ]);
                }
              },
            )
          ],
        )
      )
    );
  }
}

Future getPostData(String uid, String pid) async {
  _post = await _firestoreService.getPost(pid);
  _postUser = await _firestoreService.getUser(uid);
}