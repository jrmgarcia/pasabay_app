import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/widgets/post_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ActivePostsViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Future limitPost() async {
    await _dialogService.showDialog(
      title: "Limit Post",
      description: "You are only allowed to create up to five posts."
    );
  }

  PostItem buildItem(Post post) {
    return PostItem(
      post: post,
      onDeleteItem: () => deletePost(post),
      onTap: () => updatePost(post)
    );
  }

  void updatePost(Post post) async {
    _navigationService.navigateTo(CreatePostViewRoute, arguments: post);
  }

  void deletePost(Post post) async {

    QuerySnapshot checkTransactions = await Firestore.instance.collection('transactions')
      .where('postId', isEqualTo: post.pid)
      .getDocuments();
    
    if (checkTransactions.documents.length > 0) {
      await _dialogService.showDialog(
        title: "Delete a Post",
        description: "You can't delete post with existing transactions. Just wait for it to be fulfilled or expired."
      );
    } else {
      var postToDeleteTitle = post.title;
    
      var dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Delete a Post',
        description: 'Do you really want to delete \'$postToDeleteTitle\'?',
        confirmationTitle: 'Yes',
        cancelTitle: 'No',
      );

      if (dialogResponse.confirmed) {
        await Firestore.instance.collection('posts').document(post.pid).delete();
        _navigationService.navigateTo(HomeViewRoute);
      }
    }    
  }
}
