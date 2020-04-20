import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class TransactionView extends StatelessWidget {

  final NavigationService _navigationService = locator<NavigationService>();

  Stream<List<Task>> getData() async* {
    var tasksStream = Firestore.instance.collection('transactions').snapshots();
    var tasks = List<Task>();
    await for (var tasksSnapshot in tasksStream) {
      for (var taskDoc in tasksSnapshot.documents) {
        var task;
        if (taskDoc["userId"] != null) {
          var userSnapshot = await Firestore.instance.collection('users').document(taskDoc['userId']).get();
          var postSnapshot = await Firestore.instance.collection('posts').document(taskDoc['postId']).get();
          task = Task(
            taskDoc["postId"],
            taskDoc["userId"],
            taskDoc["doerId"],
            postSnapshot["title"], 
            postSnapshot["category"], 
            postSnapshot["reward"], 
            userSnapshot["photoUrl"], 
            userSnapshot["displayName"], 
            userSnapshot["rating"]
          );
        }
        else task = Task(null, null, null, null, null, null, null, null, null);
        tasks.add(task);
      }
      yield tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    var streamBuilder = StreamBuilder<List<Task>>(
      stream: getData(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> messagesSnapshot) {
        if (messagesSnapshot.hasError)
          return Text('Error: ${messagesSnapshot.error}');
        switch (messagesSnapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: EdgeInsets.all(8),
              children: messagesSnapshot.data.map((Task task) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => _navigationService.navigateTo(MessageViewRoute, arguments: task),
                    child: ListTile(
                      leading: userPhotoUrl(task.photoUrl),
                      title: Text(
                        task.title.toUpperCase(),
                        style: Theme.of(context).textTheme.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        task.category + " • " + 
                        task.reward + " PHP" + " • " +
                        task.userName.substring(0, task.userName.indexOf(' ')) + " " + 
                        task.userRating.toString() + " ★",
                        style: Theme.of(context).textTheme.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }
            ).toList()
          );
        }
      }
    );
    return Scaffold(body: streamBuilder);
  }
}