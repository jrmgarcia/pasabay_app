import 'package:get_it/get_it.dart';
import 'package:pasabay_app/services/cloud_storage_service.dart';
import 'package:pasabay_app/services/navigation_service.dart';
import 'package:pasabay_app/services/dialog_service.dart';
import 'package:pasabay_app/services/authentication_service.dart';
import 'package:pasabay_app/services/firestore_service.dart';
import 'package:pasabay_app/utils/image_selector.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
}
