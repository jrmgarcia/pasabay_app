import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class PostsViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Post> _posts;
  List<Post> get posts => _posts;

  void listenToPosts() {
    setBusy(true);

    _firestoreService.listenToPostsRealTime().listen((postsData) {
      List<Post> updatedPosts = postsData;
      if (updatedPosts != null && updatedPosts.length > 0) {
        _posts = updatedPosts;
        notifyListeners();
      }

      setBusy(false);
    });
  }
  
  Future deletePost(int index) async {
    var postToDelete = _posts[index];
    var postToDeleteTitle = postToDelete.title;
    
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete \'$postToDeleteTitle\'?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deletePost(postToDelete.documentId);
      setBusy(false);
    }
  }

  void editPost(int index) {
    _navigationService.navigateTo(CreatePostViewRoute,
        arguments: _posts[index]);
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }
}
