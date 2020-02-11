import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Post> _posts;
  List<Post> get posts => _posts;

  Future fetchPosts() async {
    setBusy(true);
    var postsResults = await _firestoreService.getPostsOnceOff();
    setBusy(false);

    if (postsResults is List<Post>) {
      _posts = postsResults;
      notifyListeners();
    } else {
      await _dialogService.showDialog(
        title: 'Post Update Failed',
        description: postsResults
      );
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
    await fetchPosts();
  }

  void navigateToLoginView() =>
      _navigationService.navigateTo(LoginViewRoute);
}
