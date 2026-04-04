import 'package:flutter/foundation.dart';

class SearchPlaceModel with ChangeNotifier {
  var placeId;
  String? mainText;
  String? secondaryText;
  SearchPlaceModel({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  SearchPlaceModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
