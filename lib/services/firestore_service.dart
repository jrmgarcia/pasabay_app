import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');

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

  Future getPostsOnceOff() async {
    try {
      var postDocumentSnapshot = await _postsCollectionReference.getDocuments();
      if (postDocumentSnapshot.documents.isNotEmpty) {
        return postDocumentSnapshot.documents
            .map((snapshot) => Post.fromMap(snapshot.data))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {}
  }
}