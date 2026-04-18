import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/api_constants.dart';
import 'package:taxi_booking/model/address_model.dart';
import 'package:taxi_booking/model/direction_detail_model.dart';
import 'package:taxi_booking/model/place_detail_model.dart';
import 'package:taxi_booking/model/search_place_model.dart';
import 'package:taxi_booking/viewmodel/location_provider.dart';
import 'package:taxi_booking/services/network/geocoding_network_result.dart';

class NetworkRequestResult {
  static Future<String?> findLocationAddress(Position pos, context) async {
    String? placeAddress;
    String placeId = '';
    String apiKey = Platform.isIOS
        ? ApiConstants.iOSkey
        : ApiConstants.androidkey;
    var uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$apiKey',
    );
    var response = await GeoCodingNetworkResult.getUrlRequest(uri.toString());

    if (response != null &&
        response['status'] == 'OK' &&
        response['results'].isNotEmpty) {
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

  Future<List<SearchPlaceModel>> searchPlaces(
    String countryName,
    context,
  ) async {
    String apiKey = Platform.isIOS
        ? ApiConstants.iOSkey
        : ApiConstants.androidkey;
    var uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$countryName&key=$apiKey',
    );
    var response = await GeoCodingNetworkResult.getUrlRequest(uri.toString());
    if (response['status'] == 'OK') {
      var predictionList = response['predictions'];
      var listOFPredictions = (predictionList as List)
          .map((locations) => SearchPlaceModel.fromJson(locations))
          .toList();
      return listOFPredictions;
    } else {
      return Future.error('Failed to load location :: ${response['status']}');
    }
  }

  Future<void> placeInfo(String placeId, context) async {
    String apiKey = Platform.isIOS
        ? ApiConstants.iOSkey
        : ApiConstants.androidkey;

    try {
      var uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey',
      );
      var response = await GeoCodingNetworkResult.getUrlRequest(uri.toString());
      if (response['status'] == 'OK') {
        final placeDetail = response['result'] as Map<String, dynamic>?;
        if (placeDetail == null) {
          throw Exception('Failed to load location: missing result data');
        }

        final detailModel = PlaceDetailModel.fromJson(placeDetail);
        print(detailModel.name);
        Provider.of<LocationProvider>(
          context,
          listen: false,
        ).updatePickAddressInfo(detailModel);
      }
    } catch (error) {
      throw Future.error('Failed to load location: ${error.toString()}');
    }
  }

  Future<DirectionDetailModel> getDirectionDetails(
    LatLng startCoordinates,
    LatLng endCoordinates,
    context,
  ) async {
    String apiKey = Platform.isIOS
        ? ApiConstants.iOSkey
        : ApiConstants.androidkey;
    var uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${startCoordinates.latitude},${startCoordinates.longitude}&destination=${endCoordinates.latitude},${endCoordinates.longitude}&key=$apiKey',
    );
    var response = await GeoCodingNetworkResult.getUrlRequest(uri.toString());

    if (response['status'] == 'OK') {
      var directionalSteps = response['routes'][0];
      var infoPoints = DirectionDetailModel.fromJson(directionalSteps);
      return infoPoints;
    } else {
      return Future.error('Error in fetching the data:: ${response['status']}');
    }
  }

  static int estimatedFare(DirectionDetailModel directionDetails) {
    double baseFare = 3;
    double distanceFare = (directionDetails.distanceValue! / 1000) * 0.3;
    double timeFare = (directionDetails.durationValue! / 60) * 0.2;
    print(baseFare);
    print(distanceFare);

    double totalFare = baseFare + distanceFare + timeFare;
    print(totalFare);
    return totalFare.truncate();
  }
}
