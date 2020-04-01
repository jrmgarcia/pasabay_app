import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class BrowseItem extends StatelessWidget {
  final Post post;
  final User user;
  BrowseItem({
    Key key, 
    this.post, 
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: user.photoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: user.photoUrl,
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                    )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: Colors.white,
                      ),
              title: Text(post.title.toUpperCase(), style: GoogleFonts.titilliumWeb(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(post.description, style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ),
        ],
      ),
      decoration: myBoxDecoration,
    );
  }
}