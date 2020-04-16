import 'package:pasabay_app/models/chat.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/viewmodels/message_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class MessageView extends StatelessWidget {
  final Chat viewingChat;
  const MessageView({Key key, this.viewingChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessageViewModel>.withConsumer(
      viewModel: MessageViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(viewingChat.userId, style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        drawer: MyDrawer(),
        body: Center(child: Text('Chat Page')),
      )
    );
  }
}
