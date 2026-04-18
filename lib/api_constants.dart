import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApiConstants {
  static String androidkey = dotenv.get('GMC_ANDROID_KEY');
  static String iOSkey = dotenv.get('GMC_IOS_KEY');
  static String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/';

  ///https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY
  // final headers = {
  //   'Authorization': 'Bearer $access_token',
  //   'accept': 'application/json',
  // };

  final headers = {'accept': 'application/json'};
  static final bk_intialPosition = CameraPosition(
    target: LatLng(28.66929, 77.1033),
    zoom: 14,
  );
}
