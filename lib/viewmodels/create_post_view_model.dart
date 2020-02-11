import 'package:flutter/cupertino.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class CreatePostViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();



  Future addPost({@required String title}) async {
    setBusy(true);
    var result = await _firestoreService.addPost(Post(title: title, userId: currentUser.uid));
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could Not Create Post',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Post Successfully Added',
        description: 'Your post has been created.',
      );
    }

    _navigationService.pop();
  }
}
