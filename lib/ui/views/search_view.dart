import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';

class SearchView extends StatelessWidget {
  SearchView({Key key}) : super(key: key);

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Search", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: myBackButton(context)
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: SearchBar<Task>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          searchBarStyle: SearchBarStyle(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5)
          ),
          cancellationWidget: Icon(FontAwesomeIcons.times),
          icon: Icon(FontAwesomeIcons.search),
          hintText: "What are you looking for?",
          emptyWidget: Center(child: Text("Your search did not match any posts.")),
          minimumChars: 1,
          onSearch: search,
          onItemFound: (Task task, int index) {
            final timestamp = DateTime.parse(task.timestamp);
            final daysAgo = DateTime.now().difference(timestamp).inDays;
            if (task.userId == _authenticationService.currentUser.uid || _authenticationService.currentUser.blacklist.contains(task.userId) || daysAgo > 7) {
              return SizedBox();
            } else return InkWell(
                onTap: () => _navigationService.navigateTo(ViewPostViewRoute, arguments: task),
                child: ListTile(
                  leading: Icon(categoryIcon(task.category), color: Theme.of(context).accentColor),
                  title: Text(task.title)
                ),
              );
          },
        ),
      ),
    );
  }

  Future<List<Task>> search(String searchKey) async {
    var results = await _firestoreService.searchByTitle(searchKey.toLowerCase()); 
    return results;
  }
}
