import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function onDeleteItem;
  PostItem({
    Key key, 
    this.post, 
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: Icon(categoryIcon(post.category), color: Colors.white),
              title: Text(post.title, style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(FontAwesomeIcons.times, color: Colors.white),
                onPressed: () {
                  if (onDeleteItem != null) {
                    onDeleteItem();
                  }
                },
              ),
            )
          ),
        ],
      ),
      decoration: myBoxDecoration,
    );
  }

  IconData categoryIcon(String category) {
    switch(category) {
      case 'Cleaning': 
        return FontAwesomeIcons.broom;
        break;
      case 'Delivery': 
        return FontAwesomeIcons.truck;
        break;
      case 'Officework': 
        return FontAwesomeIcons.briefcase;
        break;
      case 'Pet Sitting': 
        return FontAwesomeIcons.paw;
        break;
      case 'Schoolwork': 
        return FontAwesomeIcons.graduationCap;
        break;
      default: 
        return FontAwesomeIcons.bug;
    }
  }
}