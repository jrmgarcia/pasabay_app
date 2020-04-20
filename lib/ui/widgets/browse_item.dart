import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class BrowseItem extends StatelessWidget {
  final Post post;
  final User user;
  final Function onTap;
  BrowseItem({
    Key key, 
    this.post,
    this.user,
    this.onTap
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
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            ListTile(
              leading: userPhotoUrl(user.photoUrl),
              title: Text(
                post.title.toUpperCase(),
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                post.description, 
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              )
            ),
            Positioned(right: 50, child: VerticalDivider()),
            Positioned(
              top: 5, 
              right: 10,
              child: Text(
                timeAgo(post.timestamp) ?? ' ', 
                style: Theme.of(context).textTheme.body2.apply(color: Theme.of(context).accentColor)
              )
            )
          ]
        ),
      ),
    );
  }
}

String timeAgo(String formattedString) {
  final timestamp = DateTime.parse(formattedString);
  final difference = DateTime.now().difference(timestamp);
  final timeAgo = DateTime.now().subtract(Duration(minutes: difference.inMinutes));
  return timeago.format(timeAgo, locale: 'en_short');
}