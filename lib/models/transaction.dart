import 'package:flutter/foundation.dart';

class TransactionHistory {
  final String postId;
  final String userId;
  final String doerId;

  TransactionHistory({
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
}