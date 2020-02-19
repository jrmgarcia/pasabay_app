import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class BrowseViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

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
  
}
