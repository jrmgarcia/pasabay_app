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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      child: ListTile(
        leading: Icon(categoryIcon(post.category), color: Theme.of(context).accentColor),
        title: Text(post.title, style: TextStyle(
            color: Color(0xFF888888),
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Tooltip(message: 'Delete', child: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor)),
          onPressed: () {
            if (onDeleteItem != null) {
              onDeleteItem();
            }
          },
        ),
      ),
      decoration: myBoxDecoration,
    );
  }
}