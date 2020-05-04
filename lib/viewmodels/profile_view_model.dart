import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future block({String blockedBy, String blockedUser}) async {
    await _firestoreService.blockUser(blockedBy, blockedUser);
    await _dialogService.showDialog(
      title: 'Block a user',
      description: 'User has been blocked.',
    );
    await _navigationService.navigateTo(HomeViewRoute);
  }
}
