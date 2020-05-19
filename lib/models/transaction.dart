import 'package:flutter/foundation.dart';

class TransactionHistory {
  final String postId;
  final String userId;
  final String doerId;
  final List<dynamic> uids;

  TransactionHistory({
    @required this.postId,
    @required this.userId,
    @required this.doerId,
    this.uids
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'doerId': doerId,
      'uids': [userId, doerId]
    };
  }
}