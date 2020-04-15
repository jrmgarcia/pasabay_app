import 'package:flutter/material.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/widgets/browse_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ChatViewModel extends BaseModel {

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

}