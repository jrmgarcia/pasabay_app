import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/widgets/post_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class PostsViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  PostItem buildItem(DocumentSnapshot doc) {
    return PostItem(
      post: Post.fromMap(doc.data, doc.documentID),
      onDeleteItem: () => deletePost(doc),
    );
  }

  void updatePost(DocumentSnapshot doc) async {
    _navigationService.navigateTo(CreatePostViewRoute, arguments: Post.fromMap(doc.data, doc.documentID));
  }

  void deletePost(DocumentSnapshot doc) async {
    var postToDelete = doc;
    var postToDeleteTitle = postToDelete.data['title'];
    
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete \'$postToDeleteTitle\'?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      await Firestore.instance.collection('posts').document(doc.documentID).delete();
    }
  }
}
