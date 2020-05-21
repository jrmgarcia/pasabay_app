import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class CurrentView extends StatelessWidget {

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    final currentUser = _authenticationService.currentUser;
    var streamBuilder = StreamBuilder<List<Task>>(
      stream: _firestoreService.getTransactionData(currentUser.uid),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> messagesSnapshot) {
        if (messagesSnapshot.hasError)
          return Text('Error: ${messagesSnapshot.error}');
        switch (messagesSnapshot.connectionState) {
          case ConnectionState.waiting: return shimmerCard(context);
          default:
            return ListView(
              padding: EdgeInsets.all(8),
              children: messagesSnapshot.data.map((Task task) {
                var timestamp = DateTime.parse(task.timestamp);
                var timeInMinutes = DateTime.now().difference(timestamp).inMinutes;
                if ((task.userId == currentUser.uid || task.doerId == currentUser.uid)
                  && !currentUser.blacklist.contains(task.userId) 
                  && !currentUser.blacklist.contains(task.doerId)
                  && task.fulfilledBy == null
                  && timeInMinutes < 10080) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () async {
                        await Firestore.instance.collection('users').document(currentUser.uid).updateData({'chattingWith': currentUser.uid == task.userId ? task.doerId : task.userId});
                        await _navigationService.navigateTo(MessageViewRoute, arguments: task);  
                      },
                      child: ListTile(
                        leading: userPhotoUrl(currentUser.uid == task.userId ? task.doerAvatar : task.userAvatar),
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
                        trailing: IconButton(
                          tooltip: 'Archive',
                          icon: Icon(FontAwesomeIcons.minus, color: Theme.of(context).accentColor),
                          onPressed: () async {
                            QuerySnapshot transaction = await Firestore.instance.collection('transactions')
                              .where('postId', isEqualTo: task.postId)
                              .where('userId', isEqualTo: task.userId)
                              .where('doerId', isEqualTo: task.doerId)
                              .getDocuments();
                            var tid = transaction.documents.first.documentID;
                            
                            var transactionToArchive = task.title;
    
                            var dialogResponse = await _dialogService.showConfirmationDialog(
                              title: 'Archive Transaction',
                              description: 'Archiving a transaction hides it from your inbox until the next time you chat with that person. Do you really want to archive \'$transactionToArchive\'?',
                              confirmationTitle: 'Yes',
                              cancelTitle: 'No',
                            );

                            if (dialogResponse.confirmed) {
                              await Firestore.instance.collection('transactions').document(tid).delete();
                            }
                          },
                        )
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