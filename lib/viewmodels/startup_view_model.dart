import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';

import 'base_model.dart';

class StartUpViewModel extends BaseModel {

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      await _authenticationService.syncUserProfile(currentUser.uid);
      await _navigationService.navigateTo(HomeViewRoute);
    } else {
      await _navigationService.navigateTo(OnboardingViewRoute);
    }
  }
}