import 'package:flutter/foundation.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/chat.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ViewPostViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future addChat({
    @required String postId, 
    @required String userId
  }) async {

    setBusy(true);

    await _firestoreService.addChat(Chat(
      postId: postId, 
      userId: userId,
      doerId: currentUser.uid
    ));
    
    setBusy(false);

    _navigationService.pop();
  }

}