import 'package:flutter/foundation.dart';

class Chat {
  final String postId;
  final String userId;
  final String doerId;

  Chat({
    @required this.postId,
    @required this.userId,
    @required this.doerId
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'doerId': doerId
    };
  }

  static Chat fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Chat(
      postId: map['postId'],
      userId: map['userId'],
      doerId: map['doerId']
    );
  }
}