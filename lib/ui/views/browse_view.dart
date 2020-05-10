import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class BrowseView extends StatelessWidget {
  final String browsingCategory;
  BrowseView({Key key, this.browsingCategory}) : super(key: key);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: myBackButton(context)
      ),
      body: StreamBuilder<List<Task>>(
        stream: _firestoreService.getBrowseData(browsingCategory),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> messagesSnapshot) {
          if (messagesSnapshot.hasError)
            return Text('Error: ${messagesSnapshot.error}');
          switch (messagesSnapshot.connectionState) {
            case ConnectionState.waiting: return shimmerCard(context);
            default:
              return ListView(
                padding: EdgeInsets.all(8),
                children: messagesSnapshot.data.map((Task task) {
                  if (task.userId == _authenticationService.currentUser.uid || _authenticationService.currentUser.blacklist.contains(task.userId)) {
                    return SizedBox();
                  } else {
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () => _navigationService.navigateTo(ViewPostViewRoute, arguments: task),
                        child: Stack(
                          overflow: Overflow.clip,
                          children: <Widget>[
                            ListTile(
                              leading: userPhotoUrl(task.userAvatar ?? ' '),
                              title: Text(
                                task.title.toUpperCase() ?? ' ',
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                task.category + " • " + 
                                task.reward + " PHP • " +
                                task.userName.substring(0, task.userName.indexOf(' ')) + " " + task.userRating.toStringAsFixed(2) + " ★\n" +
                                task.description, 
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ),
                            Positioned(right: 50, child: VerticalDivider()),
                            Positioned(
                              top: 5, 
                              right: 10,
                              child: Text(
                                timeAgo(task.timestamp) ?? ' ', 
                                style: Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).accentColor)
                              )
                            )
                          ]
                        ),
                      ),
                    );
                  }
                }
              ).toList()
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(FontAwesomeIcons.search, color: Colors.white),
        onPressed: () => _navigationService.navigateTo(SearchViewRoute),
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