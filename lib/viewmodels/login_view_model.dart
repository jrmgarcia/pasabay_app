import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signIn() async {
    setBusy(true);

    var result = await _authenticationService.signInWithGoogle();

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _authenticationService.syncUserProfile(_authenticationService.currentUser.uid);
        await _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign In Failure'
        );
      }
    }
  }
}