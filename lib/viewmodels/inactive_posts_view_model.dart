import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/post.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';
import 'dart:math' as math;

class InactivePostsViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Widget buildItem(BuildContext context, Post post) {
    var timestamp = DateTime.parse(post.timestamp);
    var timeInMinutes = DateTime.now().difference(timestamp).inMinutes;
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        Icon(categoryIcon(post.category), color: Theme.of(context).accentColor),
                        horizontalSpaceMedium,
                        Expanded(
                          child: Text(
                            post.title + " • " + post.reward + " PHP",
                            style: Theme.of(context).textTheme.subtitle1
                          ),
                        ),
                        ExpandableIcon(
                          theme: ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Theme.of(context).accentColor,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(post.description, style: Theme.of(context).textTheme.bodyText2),
                        verticalSpaceSmall,
                        post.fulfilledBy != null
                        ? Text("Fulfilled by User#" + post.fulfilledBy, style: Theme.of(context).textTheme.overline)
                        : timeInMinutes > 10080
                          ? Text("Post Expired".toUpperCase(), style: Theme.of(context).textTheme.overline)
                          : Text("")
                      ]
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
