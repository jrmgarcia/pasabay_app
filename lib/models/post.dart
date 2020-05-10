import 'package:flutter/foundation.dart';

class Post {
  final String title;
  final String userId;
  final String documentId;
  final String reward;
  final String description;
  final String category;
  final String timestamp;
  final String fulfilledBy;
  final bool userRated;
  final bool doerRated;
  final List<String> searchIndex;

  Post({
    @required this.userId,
    @required this.title,
    @required this.category,
    this.documentId,
    this.reward,
    this.description,
    this.timestamp,
    this.fulfilledBy,
    this.userRated,
    this.doerRated,
    this.searchIndex
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'documentId': documentId, 
      'reward': reward, 
      'description': description, 
      'category': category,
      'timestamp': DateTime.now().toString(),
      'fulfilledBy': null,
      'userRated': false,
      'doerRated': false,
      'searchIndex': searchIndex
    };
  }
}