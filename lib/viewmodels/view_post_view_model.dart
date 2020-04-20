import 'package:flutter/foundation.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/models/transaction.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ViewPostViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future createTransaction({
    @required Task task
  }) async {
    setBusy(true);

    var transaction = TransactionHistory(
      postId: task.postId, 
      userId: task.userId,
      doerId: task.doerId
    );

    await _firestoreService.createTransaction(transaction);
    
    setBusy(false);

    _navigationService.navigateTo(MessageViewRoute, arguments: task);
  }

}