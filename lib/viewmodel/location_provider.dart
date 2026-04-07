import 'package:flutter/material.dart';
import 'package:taxi_booking/model/address_model.dart';
import 'package:taxi_booking/model/place_detail_model.dart';
import 'package:taxi_booking/model/search_place_model.dart';

class LocationProvider with ChangeNotifier {
  AddressModel? pickAddress;
  SearchPlaceModel? destinationAddress;
  PlaceDetailModel? placeDestinationAddress;

  void updatePickDestination(SearchPlaceModel destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  void updatePickAddressInfo(PlaceDetailModel placeInfo) {
    placeDestinationAddress = placeInfo;
    notifyListeners();
  }

  void updatePickUpAddress(AddressModel pickup) {
    pickAddress = pickup;
    notifyListeners();
  }
}
