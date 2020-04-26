import 'package:flutter/foundation.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/models/transaction.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ViewPostViewModel extends BaseModel {

  AuthenticationService _authenticationService = locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  Future createTransaction({
    @required Task task
  }) async {
    setBusy(true);

    var transaction = TransactionHistory(
      postId: task.postId, 
      userId: task.userId,
      doerId: _authenticationService.currentUser.uid
    );

    await _firestoreService.createTransaction(transaction);
    
    setBusy(false);

    User user = _authenticationService.currentUser;

    _navigationService.navigateTo(MessageViewRoute, 
      arguments: Task(
        task.postId,
        task.userId,
        user.uid,
        task.title,
        task.category,
        task.reward,
        task.description,
        task.timestamp,
        task.userAvatar,
        task.userName,
        task.userEmail, 
        task.userRating,
        user.photoUrl,
        user.displayName,
        user.email, 
        user.rating
      )
    );
  }

}