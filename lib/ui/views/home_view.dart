import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/my_drawer.dart';
import 'package:pasabay_app/ui/views/transaction_view.dart';
import 'package:pasabay_app/ui/views/dashboard_view.dart';
import 'package:pasabay_app/ui/views/posts_view.dart';

void main() => runApp(MaterialApp(home: HomeView()));

final AuthenticationService _authenticationService = locator<AuthenticationService>();
final NavigationService _navigationService = locator<NavigationService>();
final DialogService _dialogService = locator<DialogService>();

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

  final User currentUser = _authenticationService.currentUser;
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
      // print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUser.uid)
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
      'com.example.pasabay_app',
      'Pasabay',
      'An Errand Crowdsourcing Mobile Application for UPLB Community',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    ));
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Home", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          tooltip: 'Drawer',
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(tooltip: 'Info', icon: Icon(FontAwesomeIcons.questionCircle), onPressed: () => _navigationService.navigateTo(InfoViewRoute)),
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

  Future<bool> onBackPress() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: "Exit App",
      description: "Are you sure you want to exit the app?",
      confirmationTitle: 'Yes',
      cancelTitle: 'No'
    );
    if (dialogResponse.confirmed) {
      exit(0);
    }
    return Future.value(false);
  }
}