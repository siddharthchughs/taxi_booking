import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaceDetailModel {
  String? placeId;
  String? formattedAddress;
  String? name;
  String? icon;
  Color? iconbackgroundcolor;
  double? latitude;
  double? longitude;

  PlaceDetailModel(
    this.placeId,
    this.name,
    this.formattedAddress,
    this.icon,
    this.iconbackgroundcolor,
    this.latitude,
    this.longitude,
  );

  PlaceDetailModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    formattedAddress = json['formatted_address'];
    name = json['name'];
    icon = json['icon'];
    latitude = json['geometry']['location']['lat'];
    longitude = json['geometry']['location']['lng'];

    final iconColorString = json['icon_background_color'] as String?;
    if (iconColorString != null && iconColorString.isNotEmpty) {
      iconbackgroundcolor = Color(
        int.parse(iconColorString.replaceFirst('#', '0xff')),
      );
    }
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
