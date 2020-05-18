import 'package:pasabay_app/models/task.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/ui/views/blacklist_view.dart';
import 'package:pasabay_app/ui/views/browse_view.dart';
import 'package:pasabay_app/ui/views/info_view.dart';
import 'package:pasabay_app/ui/views/login_error_view.dart';
import 'package:pasabay_app/ui/views/privacy_policy_view.dart';
import 'package:pasabay_app/ui/views/terms_conditions_view.dart';
import 'package:pasabay_app/ui/views/transaction_view.dart';
import 'package:pasabay_app/ui/views/create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/ui/views/home_view.dart';
import 'package:pasabay_app/ui/views/login_view.dart';
import 'package:pasabay_app/ui/views/message_view.dart';
import 'package:pasabay_app/ui/views/onboarding_view.dart';
import 'package:pasabay_app/ui/views/posts_view.dart';
import 'package:pasabay_app/ui/views/profile_view.dart';
import 'package:pasabay_app/ui/views/search_view.dart';
import 'package:pasabay_app/ui/views/view_post_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OnboardingView(),
      );
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
    case BrowseViewRoute:
      var categoryToBrowse = settings.arguments as String;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BrowseView(browsingCategory: categoryToBrowse),
      );
    case SearchViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SearchView(),
      );
    case TransactionViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TransactionView(),
      );
    case MessageViewRoute:
      var taskToView = settings.arguments as Task;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MessageView(viewingTask: taskToView),
      );
    case ProfileViewRoute:
      var userToView = settings.arguments as User;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(viewingUser: userToView),
      );
    case PostsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PostsView(),
      );
    case CreatePostViewRoute:
      var postToEdit = settings.arguments as Post;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreatePostView(
          editingPost: postToEdit,
        ),
      );
    case ViewPostViewRoute:
      var postToView = settings.arguments as Task;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ViewPostView(
          viewingPost: postToView,
        ),
      );
    case BlacklistViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BlacklistView(),
      );
    case InfoViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InfoView(),
      );
    case LoginErrorViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginErrorView(),
      );
    case PrivacyPolicyViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PrivacyPolicyView(),
      );
    case TermsConditionsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TermsConditionsView(),
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
