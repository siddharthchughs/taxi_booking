import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/services/init_getit.dart';
import 'package:taxi_booking/services/navigation/navigation_service.dart';
import 'package:taxi_booking/services/network/network_request_result.dart';
import 'package:taxi_booking/style/view_style.dart';
import 'package:taxi_booking/viewmodel/location_provider.dart';
import 'package:taxi_booking/widget/screens/search_screen.dart';

class MyRideScreen extends StatefulWidget {
  const MyRideScreen({super.key});

  @override
  State<MyRideScreen> createState() => _MyRideState();
}

class _MyRideState extends State<MyRideScreen> {
  double mapBottomPadding = 0.0;
  var userDestinationName = '';
  late Position currentPosition;
  late GoogleMapController _controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final destinationFormKey = GlobalKey<FormState>();
  double searchBannerHeight = Platform.isIOS ? 300 : 310;
  final Completer<GoogleMapController> _mapController = Completer();
  bool isLocationEnabledChecked = false;
  //  late Future<Position> Function() _currentPositionFuture;

  @override
  void initState() {
    myCurrentLocation();
    super.initState();
  }

  void _userCurrentPosition() async {
    isLocationEnabledChecked = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabledChecked) {
      print('Location services are disabled.');
      return;
    }

    //   // 2. Check and Request Permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
      return;
    }

    Position newPosition = await Geolocator.getCurrentPosition();

    currentPosition = newPosition;
    print('currentPosition: $currentPosition');

    LatLng postionByLatLng = LatLng(
      newPosition.latitude,
      newPosition.longitude,
    );
    CameraPosition locationcamera = CameraPosition(
      target: postionByLatLng,
      zoom: 14,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(locationcamera));

    await NetworkRequestResult.findLocationAddress(currentPosition, context);
  }

  void myCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    currentPosition = position;
    LatLng postionByLatLng = LatLng(position.latitude, position.longitude);
    print('postionByLatLng: $postionByLatLng');
    CameraPosition locationcamera = CameraPosition(
      target: postionByLatLng,
      zoom: 14,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(locationcamera));
  }

  static final bk_intialPosition = CameraPosition(
    target: LatLng(28.66929, 77.1033),
    zoom: 14,
  );

  double getButtonBottomPadding() {
    if (Platform.isIOS) {
      return searchBannerHeight + 20;
    } else {
      return searchBannerHeight + 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: 80,
      color: Colors.yellow,
      child: Column(
        children: [CircularProgressIndicator(), SizedBox(height: 20)],
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue.shade500,
      drawer: Container(
        width: 280,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle_rounded, size: 48),
                      SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Siddharth Chugh', style: bt_Drawer_TitleStyle),
                          Text('View profile', style: bt_Drawer_SubTitleStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 1.0, height: 1, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.wallet_giftcard_outlined, size: 30),
                      title: Text(
                        'Siddharth Chugh',
                        style: bt_Drawer_TitleStyle,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.payment_outlined, size: 30),
                      title: Text(
                        'Siddharth Chugh',
                        style: bt_Drawer_TitleStyle,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.history_outlined, size: 30),
                      title: Text(
                        'Siddharth Chugh',
                        style: bt_Drawer_TitleStyle,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.contact_support_outlined, size: 30),
                      title: Text(
                        'Siddharth Chugh',
                        style: bt_Drawer_TitleStyle,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.info_outline, size: 30),
                      title: Text(
                        'Siddharth Chugh',
                        style: bt_Drawer_TitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationEnabled: true, // Shows the "My Location" layer
            myLocationButtonEnabled: false,
            initialCameraPosition: bk_intialPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              _controller = controller;

              setState(() {
                mapBottomPadding = Platform.isIOS ? 300 : 320;
                getButtonBottomPadding();
              });
              _userCurrentPosition();
            },
          ),
          Positioned(
            top: 44,
            left: 20,
            child: InkWell(
              onTap: () => scaffoldKey.currentState!.openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white12,
                  radius: 20,
                  child: Icon(Icons.menu_outlined),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              height: searchBannerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Where to?',
                      style: TextStyle(fontSize: 16, fontFamily: 'Brand-Bold'),
                    ),
                    SizedBox(height: 14.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              getIt<NavigationService>().navigateTo(
                                SearchScreen(),
                              );
                            },
                            icon: Icon(Icons.search_rounded),
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: homeUserInputField(
                              nameInput: userDestinationName,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(height: 2),

                    Expanded(
                      child: Consumer(
                        builder:
                            (
                              context,
                              LocationProvider locationProvider,
                              child,
                            ) {
                              return SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.home_outlined,
                                    color: Colors.amberAccent.shade700,
                                  ),
                                  title: Text(
                                    locationProvider
                                            .pickAddress
                                            ?.formattedAddres ??
                                        'No Address Available !',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Brand-Bold',
                                    ),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                  ),

                                  subtitle: Text(
                                    'Your Residentail address',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              );
                            },
                      ),
                    ),

                    Divider(height: 0.5, color: Colors.black12, thickness: 1.0),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        leading: Icon(
                          Icons.work_outline,
                          color: Colors.amberAccent.shade700,
                        ),
                        title: Text(
                          'Location 2',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Brand-Bold',
                          ),
                        ),
                        subtitle: Text(
                          'Your Work address',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom:
                searchBannerHeight +
                16, // Places it 16px above your white bottom sheet
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true, // Standard size for map buttons
              onPressed: () {
                myCurrentLocation();
                // Call your existing function to animate the camera
              },
              child: Icon(Icons.my_location, color: Colors.blueAccent.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget homeUserInputField({required String nameInput}) {
    return TextFormField(
      readOnly: true,
      autofocus: false,
      initialValue: nameInput,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        hintText: 'Search destination',
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      validator: (newUpdatedValue) {
        if (newUpdatedValue == null ||
            newUpdatedValue.isEmpty ||
            newUpdatedValue.trim().length <= 1) {
          return 'Please enter an email address';
        }
        return null;
      },
      maxLines: 1,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      onSaved: (updateUsername) {
        userDestinationName = updateUsername!;
      },
    );
  }
}
