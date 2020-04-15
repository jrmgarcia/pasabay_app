import 'package:flutter/foundation.dart';
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

    var result;
    
    if (!_editing) {
      result = await _firestoreService.addPost(Post(
        title: title, 
        userId: currentUser.uid,
        reward: reward,
        description: description,
        category: _selectedCategory,
      ));
    } else {
      result = await _firestoreService.updatePost(Post(
        title: title,
        userId: _editingPost.userId,
        reward: reward,
        description: description,
        category: _selectedCategory,
        documentId: _editingPost.documentId,
      ));
    }
    
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Could not create post',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Create a post',
        description: 'Your post has been created.',
      );
    }

    _navigationService.pop();
  }

  void setEditingPost(Post editingPost) {
    _editingPost = editingPost;
  }
}
