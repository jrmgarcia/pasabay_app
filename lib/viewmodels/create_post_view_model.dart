import 'package:flutter/foundation.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';
import 'package:pasabay_app/constants/route_names.dart';

class CreatePostViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String _selectedCategory = 'Select Category';
  String get selectedCategory => _selectedCategory;

  Post _editingPost;
  bool get _editing => _editingPost != null;

  void setSelectedCategory(dynamic category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future addPost({
    @required String title, 
    @required String reward, 
    @required String description,
  }) async {
    setBusy(true);

    List<String> splitList = title.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    var result;
    
    if (!_editing) {
      result = await _firestoreService.addPost(Post(
        title: title, 
        userId: currentUser.uid,
        reward: reward,
        description: description,
        category: _selectedCategory,
        searchIndex: indexList
      ));
    } else {
      result = await _firestoreService.updatePost(Post(
        title: title,
        userId: _editingPost.userId,
        reward: reward,
        description: description,
        category: _selectedCategory,
        pid: _editingPost.pid,
        searchIndex: indexList
      ));
    }
    
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not create post',
        description: result,
      );
    } else {
      if (!_editing) {
        await _dialogService.showDialog(
          title: 'Create a Post',
          description: 'Your post has been created.',
        );
      } else {
        await _dialogService.showDialog(
          title: 'Edit a Post',
          description: 'Your post has been edited.',
        );
      }
    }

    await _navigationService.navigateTo(HomeViewRoute);
  }

  void setEditingPost(Post editingPost) {
    _editingPost = editingPost;
  }
}
