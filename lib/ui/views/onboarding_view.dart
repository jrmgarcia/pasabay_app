import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/ui/shared/shared_styles.dart';
import 'package:pasabay_app/ui/shared/ui_helpers.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  NavigationService _navigationService = locator<NavigationService>();

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 16.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.white, width: 2)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight]
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () => _navigationService.navigateTo(LoginViewRoute),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              child: Image.asset('assets/images/pasabay_logo.png', height: 90),
                            ),
                            verticalSpaceLarge,
                            SizedBox(
                              child: Image.asset('assets/images/pasabay_icon.png', height: 210),
                            ),
                            verticalSpaceLarge,
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                child: Image.asset('assets/images/onboarding-1.PNG', height: 360),
                              ),
                            ),
                            Text(
                              'Get your tasks done!',
                              style: myTitleStyle1,
                              textAlign: TextAlign.center,
                            ),
                            verticalSpaceMedium,
                            Text(
                              'Post what you need to get done, how to do it, and how much you are willing to pay for it.',
                              style: mySubtitleStyle1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                child: Image.asset('assets/images/onboarding-2.PNG', height: 360),
                              ),
                            ),

                            Text(
                              'Make extra income!',
                              style: myTitleStyle1,
                              textAlign: TextAlign.center,
                            ),
                            verticalSpaceMedium,
                            Text(
                              'Get things done and earn some cash.',
                              style: mySubtitleStyle1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              child: GestureDetector(
                onTap: () => _navigationService.navigateTo(LoginViewRoute),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Get started!',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}