import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/model/address_model.dart';
import 'package:taxi_booking/provider/location_provider.dart';
import 'package:taxi_booking/services/network/geocoding_network_result.dart';

class HelperMethod {
  static Future<String> findLocationAddress(Position pos, context) async {
    String placeAddress = '';
    String placeId = '';
    // var connectvityResult = Connectivity().onConnectivityChanged;
    // if (connectvityResult != ConnectivityResult.mobile &&
    //     connectvityResult != ConnectivityResult.wifi) {
    //   return placeAddress;
    // }

    var uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=AIzaSyBTWbhCimcwXcTzYie6oFF8-gUzmGz5fac',
    );
    var response = await GeoCodingNetworkResult.getGeoAddressRequest(
      uri.toString(),
    );

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      placeId = response['results'][0]['place_id'];
      AddressModel addressModel = AddressModel(
        placeId: placeId,
        latitude: pos.latitude,
        longitude: pos.longitude,
        formattedAddres: placeAddress,
      );
      Provider.of<LocationProvider>(
        context,
        listen: false,
      ).updatePickUpAddress(addressModel);
    }

    return placeAddress;
  }
}
