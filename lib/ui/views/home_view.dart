import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:pasabay_app/ui/views/transaction_view.dart';
import 'package:pasabay_app/ui/views/dashboard_view.dart';
import 'package:pasabay_app/ui/views/posts_view.dart';

void main() => runApp(MaterialApp(home: HomeView()));

final AuthenticationService _authenticationService = locator<AuthenticationService>();

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int pageIndex = 0;

  // Initialize all pages
  final PostsView _postsView = PostsView();
  final DashboardView _dashboardView = DashboardView();
  final TransactionView _transactionView = TransactionView();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _showPage = DashboardView();

  Widget _pageChooser(int page) {
    switch(page) {
      case 0:
        return _postsView;
        break;
      case 1:
        return _dashboardView;
        break;
      case 2:
        return _transactionView;
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

  final String currentUserId = _authenticationService.currentUser.uid;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.example.pasabay_app'
          : 'com.example.pasabay_app',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          tooltip: 'Drawer',
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(tooltip: 'Info', icon: Icon(FontAwesomeIcons.questionCircle), onPressed: () {}),
        ],
      ),
      drawer: MyDrawer(),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Container(
          color: Colors.white,
          child: Center(
            child: _showPage,
          ),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _showPage = _pageChooser(index);
          });
        },
      )
    );
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)), color: Theme.of(context).primaryColor),
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.only(bottom: 25.0, top: 25.0),
                height: 150.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: Theme.of(context).textTheme.headline6
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: Theme.of(context).textTheme.subtitle1
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        FontAwesomeIcons.timesCircle,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text('CANCEL', style: Theme.of(context).textTheme.subtitle2)
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        FontAwesomeIcons.checkCircle,
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text('YES', style: Theme.of(context).textTheme.subtitle2)
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }
}