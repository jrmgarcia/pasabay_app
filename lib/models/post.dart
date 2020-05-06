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

  Post.fromData(Map<String, dynamic> data)
      : title = data['title'],
        userId = data['userId'],
        documentId = data['documentId'],
        reward = data['reward'],
        description = data['description'],
        category = data['category'],
        timestamp = data['timestamp'],
        fulfilledBy = data['fulfilledBy'],
        userRated = data['userRated'],
        doerRated = data['doerRated'],
        searchIndex = data['searchIndex'];

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

  static Post fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Post(
      userId: map['userId'],
      title: map['title'],
      reward: map['reward'],
      description: map['description'],
      category: map['category'],
      timestamp: map['timestamp'],
      fulfilledBy: map['fulfilledBy'],
      userRated: map['userRated'],
      doerRated: map['doerRated'],
      documentId: documentId,
    );
  }
}