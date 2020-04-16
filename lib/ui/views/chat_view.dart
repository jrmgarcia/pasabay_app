import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/viewmodels/chat_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

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
              stream: Firestore.instance.collection('chats').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return Column(
                    children: snapshot.data.documents.map((doc) => 
                      InkWell(
                        onTap: () => model.viewMessage(doc),
                        child: model.buildItem(doc)
                      )
                    ).toList()
                  );
                } else {
                  return Column(children: <Widget>[
                    SizedBox(height: 256), 
                    Text('No chat found.')
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