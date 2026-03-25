import 'package:get_it/get_it.dart';
import 'package:taxi_booking/services/navigation/navigation_service.dart';
import 'package:taxi_booking/services/network/helper_method.dart';
import 'package:taxi_booking/services/network/network_result.dart';

GetIt getIt = GetIt.instance;

void setUplocator() {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<NetworkConnecctivity>(
    () => NetworkConnecctivity(),
  );
  getIt.registerLazySingleton<HelperMethod>(() => HelperMethod());
}
