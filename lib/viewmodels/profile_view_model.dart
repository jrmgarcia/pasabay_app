import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  Future block({String blockedBy, String blockedUser}) async {

    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Block a user',
      description: 'Do you really want to block this user?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      await _firestoreService.blockUser(blockedBy, blockedUser);
      await _authenticationService.syncUserProfile(blockedBy);
      await _navigationService.navigateTo(HomeViewRoute);
    }

  }
}