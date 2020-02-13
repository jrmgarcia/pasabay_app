import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/cloud_storage_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/utils/image_selector.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class CreatePostViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();

  Post _editingPost;
  bool get _editing => _editingPost != null;

  File _selectedImage;
  File get selectedImage => _selectedImage;

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _selectedImage = tempImage;
      notifyListeners();
    }
  }

  Future addPost({@required String title}) async {
    setBusy(true);

    CloudStorageResult storageResult;

    if (!_editing) {
      storageResult = await _cloudStorageService.uploadImage(
        imageToUpload: _selectedImage,
        title: title,
      );
    }

    var result;
    
    if (!_editing) {
      result = await _firestoreService.addPost(Post(
        title: title, 
        userId: currentUser.uid,
        imageUrl: storageResult.imageUrl,
        imageFileName: storageResult.imageFileName,
      ));
    } else {
      result = await _firestoreService.updatePost(Post(
        title: title,
        userId: _editingPost.userId,
        documentId: _editingPost.documentId,
        imageUrl: _editingPost.imageUrl,
        imageFileName: _editingPost.imageFileName,
      ));
    }
    
    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create post',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Post successfully Added',
        description: 'Your post has been created',
      );
    }

    _navigationService.pop();
  }

  void setEditingPost(Post editingPost) {
    _editingPost = editingPost;
  }
}
