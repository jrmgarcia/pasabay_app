import 'package:expandable/expandable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'dart:math' as math;

import 'package:pasabay_app/ui/shared/ui_helpers.dart';

class InfoView extends StatelessWidget {
  InfoView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Info", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: myBackButton(context)
      ),
      drawer: MyDrawer(),
      body: MyInfoPage()
    );
  }
}

class MyInfoPage extends StatefulWidget {
  @override
  State createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> {
  @override
  Widget build(BuildContext context) {
    String postErrandDescription = "This allows you to post what you need to get done, how to do it, and how much you are willing to pay for it. All unfulfilled posts will be expired after a week. If you want to renew its expiration date, just edit the post. You are not allowed to delete posts with exisiting transactions.";
    String browseErrandsDescription = "This allows the user, who is looking for an errand, to search, sort, and ﬁlter errands.";
    String chatDescription = "This allows the users to transact with each other in order to further clarify the scope of selected errand through sending of texts and images.";
    String rateDescription = "After an errand is marked as done, you will rate your experience (on a scale of one to ﬁve stars) based on the performance of the user who completed the errand and vice versa.";
    String blockDescription = "This allows you to block users if you receive unjust treatment from them, including but not limited to, scamming and harassing. If you block a user, they cannot see your posted errands and message you. Also, it would terminate any ongoing transaction between you and the user.";
    String cleaningDescription = "This service includes sweeping and mopping ﬂoors, making beds, tidying, bathroom cleaning, vacuuming, surface cleaning, car washing, laundry and ironing, and following the customer instructions.";
    String deliveryDescription = "This service includes purchase and pick-up of desired items, groceries, food or beverages, and delivery of the purchased items to a speciﬁed location. Quantity of orders needs to be agreed upon between users before purchasing of items.";
    String officeworkDescription = "This service is on-site and includes inbound and unbound calls, typing and word processing, operating ofﬁce machines, ﬁling data entry, ofﬁce inventory and replenishment, running errands, and following the customer instructions. Customer shall provide the materials, tools, and necessary training for the doer to perform the task.";
    String petSittingDescription = "This service includes dogsitting, replenishing of pet food and water, walking dogs in permitted areas, cleaning up after dogs, and playtime.";
    String schoolworkDescription = "This service includes tutoring, editing and proofreading papers, transcribing, editing videos, designing posters, participating in focus group discussions, interviews, or surveys, statistical analysis and the likes. Customer shall provide the materials, tools, and necessary training for the doer to perform the task.";
    return Scaffold(
      body: ExpandableTheme(
        data: ExpandableThemeData(),
        child: ListView(
          padding: EdgeInsets.all(8),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Text("Features", style: Theme.of(context).textTheme.headline5),
            verticalSpaceTiny,
            buildExpandable(context, "Post Errand", FontAwesomeIcons.plus, postErrandDescription),
            buildExpandable(context, "Browse Errands", FontAwesomeIcons.tasks, browseErrandsDescription),
            buildExpandable(context, "Chat", FontAwesomeIcons.comments, chatDescription),
            buildExpandable(context, "Rate", FontAwesomeIcons.star, rateDescription),
            buildExpandable(context, "Block", FontAwesomeIcons.ban, blockDescription),
            Text("Categories", style: Theme.of(context).textTheme.headline5),
            verticalSpaceTiny,
            buildExpandable(context, Cleaning, FontAwesomeIcons.broom, cleaningDescription),
            buildExpandable(context, Delivery, FontAwesomeIcons.shoppingBasket, deliveryDescription),
            buildExpandable(context, Officework, FontAwesomeIcons.briefcase, officeworkDescription),
            buildExpandable(context, PetSitting, FontAwesomeIcons.paw, petSittingDescription),
            buildExpandable(context, Schoolwork, FontAwesomeIcons.appleAlt, schoolworkDescription),
          ],
        ),
      ),
    );
  }
}

Widget buildExpandable(BuildContext context, String label, IconData icon, String description) {
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
                      Icon(icon, color: Theme.of(context).accentColor),
                      horizontalSpaceMedium,
                      Expanded(
                        child: Text(
                          label,
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
                child: Text(description, style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
          ],
        ),
      ),
    )
  );
}