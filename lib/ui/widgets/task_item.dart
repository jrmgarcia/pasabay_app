import 'package:google_fonts/google_fonts.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final Post post;
  const TaskItem({
    Key key, 
    this.post, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
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
              leading: Icon(Icons.account_circle, color: Colors.white, size: 50),
            )
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
        ]
      ),
    );
  }
}