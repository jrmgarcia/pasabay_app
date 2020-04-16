import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/chat.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/widgets/browse_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ChatViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();

  Widget buildItem(BuildContext context, Post post, User postUser) {
    return BrowseItem(
      post: Post(
        title: post.title,
        userId: post.userId,
        documentId: post.documentId,
        reward: post.reward,
        description: post.description,
        category: post.category,
        timestamp: post.timestamp
      ),
      user: User(
        displayName: postUser.displayName, 
        email: postUser.email, 
        photoUrl: postUser.photoUrl, 
        rating: postUser.rating, 
        uid: postUser.uid
      )
    );
  }

  void viewMessage(DocumentSnapshot doc) async {
    // QuerySnapshot user = await Firestore.instance.collection('users')
    //                     .where('uid', isEqualTo: doc.data['userId'])
    //                     .getDocuments();
    // print(user.documents.first.data['photoUrl']);
    _navigationService.navigateTo(MessageViewRoute, arguments: Chat.fromMap(doc.data, doc.documentID));
  }

}