import 'package:flutter/widgets.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/authentication_service.dart';

class BaseModel extends ChangeNotifier {

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  User get currentUser => _authenticationService.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
