import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/widgets/task_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class BrowseViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();

  TaskItem buildItem(DocumentSnapshot doc) {
    return TaskItem(
      post: Post.fromMap(doc.data, doc.documentID),
    );
  }

  void viewPost(DocumentSnapshot doc) async {
    _navigationService.navigateTo(ViewPostViewRoute, arguments: Post.fromMap(doc.data, doc.documentID));
  }
}