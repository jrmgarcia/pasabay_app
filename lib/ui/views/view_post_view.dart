import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/view_post_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

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

    final taskOwner = Text(
      "John", 
      style: TextStyle(color: Colors.white)
    );

    final taskOwnerRating = Row(
      children: <Widget>[
        Text("4.5", style: TextStyle(color: Colors.white)),
        horizontalSpaceTiny,
        Icon(FontAwesomeIcons.solidStar, color: Colors.white, size: 10)
      ]
    );


    final topContentText = Column(
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
            Expanded(flex: 1, child: taskOwner),
            Expanded(flex: 2, child: taskOwnerRating),
            Expanded(flex: 1, child: taskReward)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("post_image"),
              fit: BoxFit.cover,
            ),
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.grey),
          child: Center(
            child: topContentText,
          ),
        ),
      ],
    );

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
        body: Column(
          children: <Widget>[topContent, bottomContent],
        ),
        floatingActionButton: chatButton,
      ),
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
}
