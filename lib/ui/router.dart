import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/ui/views/blacklist_view.dart';
import 'package:pasabay_app/ui/views/create_post_view.dart';
import 'package:pasabay_app/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/ui/views/login_view.dart';
import 'package:pasabay_app/ui/views/posts_view.dart';
import 'package:pasabay_app/ui/views/profile_view.dart';
import 'package:pasabay_app/ui/views/tasks_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    case PostsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PostsView(),
      );
    case TasksViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TasksView(),
      );
    case CreatePostViewRoute:
      var postToEdit = settings.arguments as Post;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreatePostView(
          editingPost: postToEdit,
        ),
      );
    case BlacklistViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BlacklistView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
