import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/transaction.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class TransactionViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();

  Widget buildItem(DocumentSnapshot doc) {
    return Card(
      child: ListTile(
        title: Text(doc.documentID),
        leading: Icon(FontAwesomeIcons.userCircle),
      )
    );
  }

  void viewMessage(DocumentSnapshot doc) async {
    var transaction = TransactionHistory(
      postId: doc.data['postId'], 
      userId: doc.data['userId'],
      doerId: doc.data['doerId']
    );

    _navigationService.navigateTo(MessageViewRoute, arguments: transaction);
  }
  
}