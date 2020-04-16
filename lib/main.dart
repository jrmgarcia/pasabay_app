import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/ui/views/startup_view.dart';
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
      // LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFEAB971),
        accentColor: Color(0xFFF6DB7F),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.black54,
          )
        ),
      ),
      // DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF212121),
        accentColor: Colors.amber,
        scaffoldBackgroundColor: Color(0xFF303030),
        cardColor: Color(0xFF424242),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
          )
        ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
