import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/views/active_posts_view.dart';
import 'package:pasabay_app/ui/views/inactive_posts_view.dart';

class PostsView extends StatelessWidget {

  final ActivePostsView _activeView = ActivePostsView();
  final InactivePostsView _inactiveView = InactivePostsView();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Container(),
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Active"),
                    Tab(text: "Inactive")
                  ],
                  labelColor: Colors.white,
                  indicatorColor: Colors.white
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _activeView,
              _inactiveView
            ],
          ),
        ),
      ),
    );
  }
}