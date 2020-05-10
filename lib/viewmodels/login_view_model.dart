import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signIn() async {
    setBusy(true);

    var result = await _authenticationService.signInWithGoogle();

    setBusy(false);

    if (result is bool) {
      RegExp regExp = new RegExp(
        r"^[A-Za-z0-9._%+-]+@up.edu.ph$",
        caseSensitive: false,
        multiLine: false,
      );
      if (result && regExp.hasMatch(_authenticationService.currentUser.email) && (_authenticationService.currentUser.rating > 2 || _authenticationService.currentUser.rating == 0)) {
        await _authenticationService.syncUserProfile(_authenticationService.currentUser.uid);
        await _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _authenticationService.signOutGoogle();
        await _navigationService.navigateTo(LoginErrorViewRoute);
      }
    }
  }
}