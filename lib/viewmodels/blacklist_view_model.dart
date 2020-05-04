import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class BlacklistViewModel extends BaseModel {
  
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future unblock(String blockedBy, String blockedUser) async {
    
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Unblock a user',
      description: 'Do you really want to unblock this user?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      await _firestoreService.unblockUser(blockedBy, blockedUser);
      await _navigationService.navigateTo(HomeViewRoute);
    }

  }
  
}
