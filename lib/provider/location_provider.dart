import 'package:flutter/material.dart';
import 'package:taxi_booking/model/address_model.dart';

class LocationProvider with ChangeNotifier {
  late AddressModel pickAddress;

  void updatePickUpAddress(AddressModel pickup) {
    pickAddress = pickup;
    notifyListeners();
  }
}
