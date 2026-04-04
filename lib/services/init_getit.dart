import 'package:get_it/get_it.dart';
import 'package:taxi_booking/services/navigation/navigation_service.dart';
import 'package:taxi_booking/services/network/network_request_result.dart';
import 'package:taxi_booking/services/network/geocoding_network_result.dart';

GetIt getIt = GetIt.instance;

void setUplocator() {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<GeoCodingNetworkResult>(
    () => GeoCodingNetworkResult(),
  );
  getIt.registerLazySingleton<NetworkRequestResult>(
    () => NetworkRequestResult(),
  );
}
