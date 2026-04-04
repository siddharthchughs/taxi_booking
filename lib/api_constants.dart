import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String androidkey = dotenv.get('GMC_ANDROID_KEY');
  static String iOSkey = dotenv.get('GMC_IOS_KEY');
  static String access_token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjIwNjkxZGYwOWEwOWU3MDA1ODQ2ODYyMWI2ZTFlNiIsIm5iZiI6MTY0ODUzOTcyMi40MzEsInN1YiI6IjYyNDJiODRhZDcxZmI0MDA0N2Y4NDY3ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VGSDh6aE1KWQiZEpkbrTudEipbalTUBtrFC9IrV5t30';
  static String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/';

  // final headers = {
  //   'Authorization': 'Bearer $access_token',
  //   'accept': 'application/json',
  // };

  final headers = {'accept': 'application/json'};
  static const String themeModeKey = 'THEME_MODE';
  static const String favoritesKey = 'favorites';
}
