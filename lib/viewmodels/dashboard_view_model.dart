import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class DashboardViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  Future navigateToCreateView() async {
    QuerySnapshot postCount = await Firestore.instance.collection('posts')
      .where('userId', isEqualTo: _authenticationService.currentUser.uid)
      .where('fulfilledBy', isNull: true)
      .getDocuments();

    if (postCount.documents.length < 5) {
      await _navigationService.navigateTo(CreatePostViewRoute);
    } else {
      await _dialogService.showDialog(
        title: "Limit Post",
        description: "You are only allowed to create up to five posts."
      );
    }
  }

  Future browseCleaning() async {
    await _navigationService.navigateTo(BrowseViewRoute, arguments: Cleaning);
  }

  Future browseDelivery() async {
    await _navigationService.navigateTo(BrowseViewRoute, arguments: Delivery);
  }

  Future browseOfficework() async {
    await _navigationService.navigateTo(BrowseViewRoute, arguments: Officework);
  }

  Future browsePetSitting() async {
    await _navigationService.navigateTo(BrowseViewRoute, arguments: PetSitting);
  }

  Future browseToSchoolwork() async {
    await _navigationService.navigateTo(BrowseViewRoute, arguments: Schoolwork);
  }
}
