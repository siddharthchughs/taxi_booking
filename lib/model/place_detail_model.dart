import 'dart:ui';

import 'package:flutter/rendering.dart';

class PlaceDetailModel {
  String? placeId;
  String? formattedAddress;
  String? name;
  String? icon;
  Color? iconbackgroundcolor;
  double? lat;
  double? lng;

  PlaceDetailModel({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.icon,
    required this.iconbackgroundcolor,
    required this.lat,
    required this.lng,
  });

  PlaceDetailModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    formattedAddress = json['address_components']['formatted_address'];
    name = json['name'];
    icon = json['icon'];
    iconbackgroundcolor = json['icon_background_color'];
    lat = json['geometry']['location'];
  }
}

class GeometryModel {
  double? lat;
  double? lng;

  GeometryModel({required this.lat, required this.lng});

  GeometryModel.fromJson(Map<String, dynamic> json) {
    lat = json['location']['lat'];
    lng = json['location']['lng'];
  }
}
