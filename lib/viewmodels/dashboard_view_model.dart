import 'package:pasabay_app/constants/route_names.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/viewmodels/base_model.dart';

class DashboardViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Future browseTo() async {
    await _navigationService.navigateTo(BrowseViewRoute);
  }
}
