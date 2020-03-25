import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:pasabay_app/ui/views/browse_view.dart';
import 'package:pasabay_app/ui/views/dashboard_view.dart';
import 'package:pasabay_app/ui/views/posts_view.dart';

void main() => runApp(MaterialApp(home: HomeView()));

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int pageIndex = 0;

  // Initialize all pages
  final PostsView _postsView = PostsView();
  final DashboardView _dashboardView = DashboardView();

  Widget _showPage = BrowseView();

  Widget _pageChooser(int page) {
    switch(page) {
      case 0:
        return _postsView;
        break;
      case 1:
        return _dashboardView;
        break;
      default:
        return Container(
          child: Center(
            child: Text(
              'No page found.'
            )
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _showPage,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        items: <Widget>[
          Icon(FontAwesomeIcons.plus, color: Colors.white),
          Icon(FontAwesomeIcons.tasks, color: Colors.white),
          Icon(FontAwesomeIcons.comments, color: Colors.white),
        ],
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _showPage = _pageChooser(index);
          });
        },
      )
    );
  }
}