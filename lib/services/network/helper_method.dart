import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_booking/api_constants.dart';
import 'package:taxi_booking/services/network/network_result.dart';

class HelperMethod {
  static Future<String> findLocationAddress(Position pos) async {
    String placeAddress = '';
    // var connectvityResult = Connectivity().onConnectivityChanged;
    // if (connectvityResult != ConnectivityResult.mobile &&
    //     connectvityResult != ConnectivityResult.wifi) {
    //   return placeAddress;
    // }

    var uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyBTWbhCimcwXcTzYie6oFF8-gUzmGz5fac',
    );

    print(uri);

    var response = await NetworkConnecctivity.getGeoAddressRequest(
      uri.toString(),
    );
    print(response);

    //    if (response != 'failed') {
    placeAddress = response['results'][0]['formatted_address'];
    //  }

    return placeAddress;
  }
}
