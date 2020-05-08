import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function onDeleteItem;
  final Function onTap;
  PostItem({
    Key key, 
    this.post, 
    this.onDeleteItem, 
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(categoryIcon(post.category), color: Theme.of(context).accentColor),
          title: Text(
            post.title, 
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            tooltip: 'Delete',
            icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor),
            onPressed: () {
              if (onDeleteItem != null) {
                onDeleteItem();
              }
            },
          ),
        ),
      ),
    );
  }
}