import 'package:flutter/foundation.dart';

class Rating {
  final String transactionId;
  final String ratingTo;
  final double rate;

  Rating({
    @required this.transactionId,
    @required this.ratingTo,
    @required this.rate
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'ratingTo': ratingTo,
      'rate': rate
    };
  }
}