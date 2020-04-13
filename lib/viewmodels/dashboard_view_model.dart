import 'package:pasabay_app/constants/category_names.dart';
import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class DashboardViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
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
