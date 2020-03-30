import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/widgets/browse_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class BrowseViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _postUser;
  User get postUser => _postUser;

  BrowseItem buildItem(DocumentSnapshot doc) {
    getPostUser(doc.data['userId']);
    return BrowseItem(
      post: Post.fromMap(doc.data, doc.documentID),
      user: User(
        uid: postUser.uid,
        displayName: postUser.displayName,
        email: postUser.email,
        photoUrl: postUser.photoUrl
      )
    );
  }

  void viewPost(DocumentSnapshot doc) async {
    _navigationService.navigateTo(ViewPostViewRoute, arguments: Post.fromMap(doc.data, doc.documentID));
  }

  Future getPostUser(String uid) async {
    _postUser = await _firestoreService.getUser(uid);
  }
}