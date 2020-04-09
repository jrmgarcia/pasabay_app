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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget taskOwner(User user) {
      return Text(
        user.displayName.substring(0, user.displayName.indexOf(' ')) ?? ' ', 
        style: TextStyle(color: Colors.white)
      );
    }

    Widget taskOwnerRating(User user) {
      return Row(
        children: <Widget>[
          Text(user.rating.toString() ?? ' ', style: TextStyle(color: Colors.white)),
          horizontalSpaceTiny,
          Icon(FontAwesomeIcons.solidStar, color: Colors.white, size: 10)
        ]
      );
    }


    Widget topContentText(User user) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 120.0),
          Icon(
            categoryIcon(viewingPost.category),
            color: Colors.white,
            size: 40.0,
          ),
          Container(
            width: 90.0,
            child: Divider(color: Colors.white),
          ),
          SizedBox(height: 10.0),
          Text(
            viewingPost.title,
            style: myTitleStyle1,
            overflow: TextOverflow.ellipsis
          ),
          SizedBox(height: 30.0),
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
      style: TextStyle(
        color: Color(0xFF888888),
        fontSize: 16.0
      ),
    );

    final chatButton = FloatingActionButton(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(FontAwesomeIcons.commentAlt, color: Colors.white),
      onPressed: () => {},
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
        ),
        body: FutureBuilder(
          future: Future.wait([getPostUser(viewingPost.userId),]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  topContent(postUser),
                  DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            child: bottomContent
                          )
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
        floatingActionButton: Tooltip(message: 'Chat', child: chatButton),
      )
    );
  }

  IconData categoryIcon(String category) {
    switch(category) {
      case 'Cleaning': 
        return FontAwesomeIcons.broom;
        break;
      case 'Delivery': 
        return FontAwesomeIcons.shoppingBasket;
        break;
      case 'Officework': 
        return FontAwesomeIcons.briefcase;
        break;
      case 'Pet Sitting': 
        return FontAwesomeIcons.paw;
        break;
      case 'Schoolwork': 
        return FontAwesomeIcons.book;
        break;
      default: 
        return FontAwesomeIcons.bug;
    }
  }

  Future getPostUser(String uid) async {
    _postUser = await _firestoreService.getUser(uid);
  }
}

