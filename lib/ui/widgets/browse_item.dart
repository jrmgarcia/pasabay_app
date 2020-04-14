import 'package:cached_network_image/cached_network_image.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class BrowseItem extends StatelessWidget {
  final Post post;
  final User user;
  BrowseItem({
    Key key, 
    this.post,
    this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(8),
      child: Container(
        height: 80,
        alignment: Alignment.center,
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            ListTile(
              leading: userPhotoUrl(post.userId, user.photoUrl),
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
        decoration: myBoxDecoration(context),
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

Widget userPhotoUrl(String uid, String photoUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        ),
        width: 50.0,
        height: 50.0,
        padding: EdgeInsets.all(15.0),
      ),
      imageUrl: photoUrl,
      width: 50.0,
      height: 50.0,
      fit: BoxFit.cover,
    ),
  );
}