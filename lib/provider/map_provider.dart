import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  CameraPosition? _initialCameraPosition;

  CameraPosition? get initialCameraPosition => _initialCameraPosition;

  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;

  final CameraPosition lastFallBackPosition = CameraPosition(
    target: LatLng(23.45, -122.08832),
    zoom: 10,
  );

  Future<void> _fetchAndSetInitialLocation() async {
    Position position = await _permissionCheckForGeolocator();
    _currentLocation = LatLng(position.latitude, position.longitude);
    _initialCameraPosition = CameraPosition(
      target: _currentLocation!,
      zoom: 14,
    );
    notifyListeners();
  }

  Future<void> getInitialCameraPosition() async {
    try {
      // Attempt to get the user's current location and set the initial camera position
      // You can use a package like geolocator to get the current location
      // For example:
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      // _initialCameraPosition = CameraPosition(
      //   target: LatLng(position.latitude, position.longitude),
      //   zoom: 14,
      // );
      Position position = await _permissionCheckForGeolocator();
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );
    } catch (e) {
      // If there's an error (e.g., location permissions denied), use the fallback position
      _initialCameraPosition = lastFallBackPosition;
    }
    notifyListeners();
  }

  Future<Position> _permissionCheckForGeolocator() async {
    bool isLocationEnabledChecked = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabledChecked) {
      return Future.error('Location services are disabled.');
    }

    // 2. Check and Request Permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    LatLng postionByLatLng = LatLng(
      newPosition.latitude,
      newPosition.longitude,
    );
    CameraPosition locationcamera = CameraPosition(
      target: postionByLatLng,
      zoom: 14,
    );

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }
}
