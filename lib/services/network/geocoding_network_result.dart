import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taxi_booking/api_constants.dart';

class GeoCodingNetworkResult {
  static Future<dynamic> getUrlRequest(String url) async {
    final uri = Uri.parse(url);
    final response = await http
        .get(uri, headers: ApiConstants().headers)
        .timeout(Duration(seconds: 30));

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response == $data');

        return data;
      } else {
        Exception('Failed to load location :: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      return;
    }
  }
}
