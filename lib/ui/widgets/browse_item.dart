import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          ListTile(
            leading: userPhotoUrl(post.userId, user.photoUrl),
            title: Text(
              post.title.toUpperCase(),
              style: GoogleFonts.titilliumWeb(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post.description, 
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ),
          Positioned(right: 50, child: VerticalDivider()),
          Positioned(
            top: 5, 
            right: 10,
            child: Text(
              timeAgo(post.timestamp) ?? ' ', 
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14
              )
            )
          )
        ]
      ),
      decoration: myBoxDecoration,
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