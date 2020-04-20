import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/models/transaction.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');
  final CollectionReference _transactionCollectionReference = 
      Firestore.instance.collection('transactions');

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toJson());
    } catch (e) {}
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {}
  }

  Future addPost(Post post) async {
    try {
      await _postsCollectionReference.add(post.toMap());
    } catch (e) {}
  }

  Future updatePost(Post post) async {
    try {
      await _postsCollectionReference
            .document(post.documentId)
            .updateData(post.toMap());
    } catch (e) {}
  }

  Future createTransaction(TransactionHistory transaction) async {
    try {
      QuerySnapshot duplicate = await _transactionCollectionReference
            .where('postId', isEqualTo: transaction.postId)
            .where('userId', isEqualTo: transaction.userId)
            .where('doerId', isEqualTo: transaction.doerId)
            .getDocuments();
      if (duplicate.documents.length == 0) {
        await _transactionCollectionReference.add(transaction.toMap());
      }
    } catch (e) {}
  }

  Future getPost(String pid) async {
    try {
      var postData = await _postsCollectionReference.document(pid).get();
      return Post.fromData(postData.data);
    } catch (e) {}
  }

  Stream<List<Task>> getChatData() async* {
    var tasksStream = Firestore.instance.collection('transactions').snapshots();
    var tasks = List<Task>();
    await for (var tasksSnapshot in tasksStream) {
      for (var taskDoc in tasksSnapshot.documents) {
        var task;
        if (taskDoc["userId"] != null) {
          var postSnapshot = await _postsCollectionReference.document(taskDoc['postId']).get();
          var userSnapshot = await _usersCollectionReference.document(taskDoc['userId']).get();
          var doerSnapshot = await _usersCollectionReference.document(taskDoc['doerId']).get();
          task = Task(
            taskDoc["postId"],
            taskDoc["userId"],
            taskDoc["doerId"],
            postSnapshot["title"], 
            postSnapshot["category"], 
            postSnapshot["reward"], 
            postSnapshot["description"], 
            postSnapshot["timestamp"], 
            userSnapshot["photoUrl"], 
            userSnapshot["displayName"], 
            userSnapshot["rating"],
            doerSnapshot["photoUrl"], 
            doerSnapshot["displayName"], 
            doerSnapshot["rating"]
          );
        }
        else task = Task(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
        tasks.add(task);
      }
      yield tasks;
    }
  }

  Stream<List<Task>> getBrowseData(String browsingCategory) async* {
    var tasksStream = Firestore.instance.collection('posts')
            .where('category', isEqualTo: browsingCategory)
            .orderBy('timestamp', descending: true)
            .snapshots();
    var tasks = List<Task>();
    await for (var tasksSnapshot in tasksStream) {
      for (var taskDoc in tasksSnapshot.documents) {
        var task;
        if (taskDoc["userId"] != null) {
          var userSnapshot = await _usersCollectionReference.document(taskDoc['userId']).get();
          task = Task(
            taskDoc.documentID,
            taskDoc["userId"],
            _authenticationService.currentUser.uid,
            taskDoc["title"], 
            taskDoc["category"], 
            taskDoc["reward"], 
            taskDoc["description"], 
            taskDoc["timestamp"], 
            userSnapshot["photoUrl"], 
            userSnapshot["displayName"], 
            userSnapshot["rating"],
            _authenticationService.currentUser.photoUrl, 
            _authenticationService.currentUser.displayName, 
            _authenticationService.currentUser.rating
          );
        }
        else task = Task(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
        tasks.add(task);
      }
      yield tasks;
    }
  }
}