import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/ui/widgets/task_item.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class BrowseViewModel extends BaseModel {

  TaskItem buildItem(DocumentSnapshot doc) {
    return TaskItem(
      post: Post.fromMap(doc.data, doc.documentID),
    );
  }
}