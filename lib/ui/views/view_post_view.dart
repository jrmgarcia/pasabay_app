import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/view_post_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

final FirestoreService _firestoreService = locator<FirestoreService>();

User _postUser;
User get postUser => _postUser;

class ViewPostView extends StatelessWidget {
  
  final Post viewingPost;
  ViewPostView({Key key, this.viewingPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final taskReward = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: Center(
        child: Text(
          "PHP " + viewingPost.reward,
          style: Theme.of(context).textTheme.title.apply(color: Colors.white),
        ),
      ),
    );

    Widget taskOwner(User user) {
      return Text(
        user.displayName.substring(0, user.displayName.indexOf(' ')) ?? ' ', 
        style: Theme.of(context).textTheme.subhead.apply(color: Colors.white)
      );
    }

    Widget taskOwnerRating(User user) {
      return Row(
        children: <Widget>[
          Text(user.rating.toString() ?? ' ', style: Theme.of(context).textTheme.subhead.apply(color: Colors.white)),
          horizontalSpaceTiny,
          Icon(FontAwesomeIcons.solidStar, color: Colors.white, size: 10)
        ]
      );
    }


    Widget topContentText(User user) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          verticalSpaceMassive,
          Icon(
            categoryIcon(viewingPost.category),
            color: Colors.white,
            size: 40.0,
          ),
          Container(
            width: 90.0,
            child: Divider(color: Colors.white),
          ),
          verticalSpaceSmall,
          Text(
            viewingPost.title,
            style: Theme.of(context).textTheme.headline.apply(color: Colors.white),
            overflow: TextOverflow.ellipsis
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 1, child: taskOwner(user)),
              Expanded(flex: 2, child: taskOwnerRating(user)),
              Expanded(flex: 1, child: taskReward)
            ],
          ),
        ],
      );
    }

    Widget topContent(User user) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  user.photoUrl ?? 'https://lh3.googleusercontent.com/-cXXaVVq8nMM/AAAAAAAAAAI/AAAAAAAAAKI/_Y1WfBiSnRI/photo.jpg?sz=50',
                ),
                fit: BoxFit.cover,
              ),
            )
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.all(40.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey[400].withOpacity(0.6)),
            child: Center(
              child: topContentText(user),
            ),
          ),
        ],
      );
    } 

    final bottomContentText = Text(
      viewingPost.description,
      style: Theme.of(context).textTheme.body1,
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return ViewModelProvider<ViewPostViewModel>.withConsumer(
      viewModel: ViewPostViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("View a Post", style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: myBackButton(context)
        ),
        body: FutureBuilder(
          future: Future.wait([getPostUser(viewingPost.userId),]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  topContent(postUser),
                  DraggableScrollableSheet(
                    builder: (context, scrollController) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: bottomContent
                            )
                          ),
                        ),
                      );
                    }
                  ),
                ]
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
        floatingActionButton: Tooltip(
          message: 'Transaction', 
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(FontAwesomeIcons.commentAlt, color: Colors.white),
            onPressed: () {
              model.createTransaction(postId: viewingPost.documentId, userId: viewingPost.userId);
            },
          )
        ),
      )
    );
  }

  Future getPostUser(String uid) async {
    _postUser = await _firestoreService.getUser(uid);
  }
}

