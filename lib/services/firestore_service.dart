import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/models/transaction.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');
  final CollectionReference _transactionCollectionReference = 
      Firestore.instance.collection('transactions');

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
}