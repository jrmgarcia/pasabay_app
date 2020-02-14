import 'package:google_fonts/google_fonts.dart';
import 'package:pasabay_app/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasabay',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFEAB971),
        primaryColorDark: Color(0xFFFDA085),
        primaryColorLight: Color(0xFFF6D365),
        accentColor: Color(0xFFF6DB7F),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
