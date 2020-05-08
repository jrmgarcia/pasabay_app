import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class TransactionView extends StatelessWidget {

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    var streamBuilder = StreamBuilder<List<Task>>(
      stream: _firestoreService.getTransactionData(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> messagesSnapshot) {
        if (messagesSnapshot.hasError)
          return Text('Error: ${messagesSnapshot.error}');
        switch (messagesSnapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: EdgeInsets.all(8),
              children: messagesSnapshot.data.map((Task task) {
                if ((task.userId == _authenticationService.currentUser.uid || task.doerId == _authenticationService.currentUser.uid) &&
                  (!_authenticationService.currentUser.blacklist.contains(task.userId) && !_authenticationService.currentUser.blacklist.contains(task.doerId))) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () => _navigationService.navigateTo(MessageViewRoute, arguments: task),
                      child: ListTile(
                        leading: userPhotoUrl(_authenticationService.currentUser.uid == task.userId ? task.doerAvatar : task.userAvatar),
                        title: Text(
                          task.title.toUpperCase(),
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          task.category + " • " + 
                          task.reward + " PHP" + "\n" + 
                          peerUser(task),
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                } else return SizedBox();
              }
            ).toList()
          );
        }
      }
    );
    return Scaffold(body: streamBuilder);
  }
}