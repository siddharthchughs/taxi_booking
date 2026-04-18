import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/api_constants.dart';
import 'package:taxi_booking/model/direction_detail_model.dart';
import 'package:taxi_booking/services/init_getit.dart';
import 'package:taxi_booking/services/network/network_request_result.dart';
import 'package:taxi_booking/style/view_style.dart';
import 'package:taxi_booking/viewmodel/location_provider.dart';
import 'package:taxi_booking/widget/custom_progressbar.dart';
import 'package:taxi_booking/widget/screens/search_screen.dart';

class MyRideScreen extends StatefulWidget {
  const MyRideScreen({super.key});

  @override
  State<MyRideScreen> createState() => _MyRideState();
}

class _MyRideState extends State<MyRideScreen> with TickerProviderStateMixin {
  double mapBottomPadding = 0.0;
  var userDestinationName = '';
  late Position currentPosition;
  late GoogleMapController _controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final destinationFormKey = GlobalKey<FormState>();
  double searchBannerHeight = Platform.isIOS ? 300 : 310;
  double rideBannerHeight = 0;
  final Completer<GoogleMapController> _mapController = Completer();
  bool isLocationEnabledChecked = false;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylinesSet = {};
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  DirectionDetailModel? tripDirectionDetail;
  bool isDrawerOpen = false;

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

  double getButtonBottomPadding() {
    if (Platform.isIOS) {
      return searchBannerHeight + 20;
    } else {
      return searchBannerHeight + 40;
    }
  }

  void updateBannerHeight() async {
    await getDirectionRoute();
    setState(() {
      searchBannerHeight = 0;
      rideBannerHeight = Platform.isIOS ? 300 : 290;
      mapBottomPadding = Platform.isIOS ? 300 : 260;
      isDrawerOpen = false;
    });
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
            initialCameraPosition: ApiConstants.bk_intialPosition,
            polylines: polylinesSet,
            markers: _markers,
            circles: _circles,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              _controller = controller;

              setState(() {
                mapBottomPadding = Platform.isIOS ? 300 : 290;
                getButtonBottomPadding();
              });
              _userCurrentPosition();
            },
          ),
          Positioned(
            top: 44,
            left: 20,
            child: InkWell(
              onTap: () {
                if (isDrawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  resetMap();
                }
              },
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
                  child: Icon(
                    (isDrawerOpen) ? Icons.menu : Icons.arrow_back,
                    color: Colors.black45,
                  ),
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

                    GestureDetector(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade400,
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
                            IconButton(
                              onPressed: () async {
                                final response = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SearchScreen();
                                    },
                                  ),
                                );
                                print('flutter :: $response');
                                if (response != null) {
                                  updateBannerHeight();
                                }
                              },
                              icon: Icon(Icons.search_rounded),
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
                    ),
                    SizedBox(height: 12),
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
              },
              child: Icon(Icons.my_location, color: Colors.blueAccent.shade400),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                height: rideBannerHeight,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.deepPurpleAccent.shade100,
                      child: rideComponent1(),
                    ),
                    ridePaymentSelectComponent(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12,
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 48,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.deepPurple.shade700,
                        onPressed: () {},
                        child: Text(
                          'Confirm Ride',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Brand-Bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rideComponent1() {
    _userCurrentPosition();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 8),
          Image.asset(
            'images/taxi.png',
            width: 100.0,
            height: 50.0,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taxi',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Text(
                  '${tripDirectionDetail?.durationText ?? 'N/A'} away',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontFamily: 'Brand-Regular',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              (tripDirectionDetail != null)
                  ? '\$${NetworkRequestResult.estimatedFare(tripDirectionDetail!)}'
                  : '\${0.00}',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget ridePaymentSelectComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 8),
          FaIcon(
            FontAwesomeIcons.moneyBillAlt,
            size: 40,
            color: Colors.blueAccent.shade400,
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cash',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    // Handle dropdown button press
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
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

  Future<void> getDirectionRoute() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomProgressbar(status: 'Finding best route...'),
    );

    var pickUp = Provider.of<LocationProvider>(
      context,
      listen: false,
    ).pickAddress;

    var destinationAddress = Provider.of<LocationProvider>(
      context,
      listen: false,
    ).placeDestinationAddress;

    if (pickUp == null || destinationAddress == null) {
      if (Navigator.canPop(context)) Navigator.pop(context); // Dismiss dialog
      return;
    }

    var pickup = LatLng(pickUp.latitude ?? 0.0, pickUp.longitude ?? 0.0);
    var destinationdrop = LatLng(
      destinationAddress.latitude ?? 0.0,
      destinationAddress.longitude ?? 0.0,
    );

    try {
      var response = await getIt<NetworkRequestResult>().getDirectionDetails(
        pickup,
        destinationdrop,
        context,
      );

      setState(() {
        tripDirectionDetail = response;
      });

      Navigator.pop(context);

      List<PointLatLng> polyPointsResult = PolylinePoints.decodePolyline(
        response.encodedPoints!,
      );

      polylineCoordinates.clear();
      if (polyPointsResult.isNotEmpty) {
        for (var points in polyPointsResult) {
          polylineCoordinates.add(LatLng(points.latitude, points.longitude));
        }
      }

      polylinesSet.clear();

      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId("polyline"),
          color: Colors.red.shade400,
          points: polylineCoordinates,
          width: 4,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );
        polylinesSet.add(polyline);
      });

      LatLngBounds bounds;

      if (pickup.latitude > destinationdrop.latitude &&
          pickup.longitude > destinationdrop.longitude) {
        bounds = LatLngBounds(southwest: destinationdrop, northeast: pickup);
      } else if (pickup.longitude > destinationdrop.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(pickup.latitude, destinationdrop.longitude),
          northeast: LatLng(destinationdrop.latitude, pickup.longitude),
        );
      } else if (pickup.latitude > destinationdrop.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationdrop.latitude, pickup.longitude),
          northeast: LatLng(pickup.latitude, destinationdrop.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: pickup, northeast: destinationdrop);
      }
      _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));
      Marker pickUpMarker = Marker(
        markerId: MarkerId('pickUpID'),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(
          title: pickUp.formattedAddres ?? 'Pickup Location',
        ),
      );

      Marker destinationMarker = Marker(
        markerId: MarkerId('destinationID'),
        position: destinationdrop,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
          title: destinationAddress.name ?? 'Destination Location',
        ),
      );

      setState(() {
        _markers.add(pickUpMarker);
        _markers.add(destinationMarker);
      });

      Circle pickupCircle = Circle(
        circleId: CircleId('pickupCircleID'),
        strokeColor: Colors.lightGreenAccent.shade200,
        strokeWidth: 3,
        radius: 12,
        center: pickup,
        fillColor: Colors.greenAccent.withOpacity(0.5),
      );
      Circle destinationCircle = Circle(
        circleId: CircleId('destinationCircleID'),
        strokeColor: Colors.redAccent,
        strokeWidth: 3,
        radius: 12,
        center: destinationdrop,
        fillColor: Colors.redAccent.withOpacity(0.5),
      );
      setState(() {
        _circles.add(pickupCircle);
        _circles.add(destinationCircle);
      });
    } catch (e) {
      print('flutter :: Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get directions: ${e.toString()}")),
        );
      }
    } finally {
      // 4. THE DISMISSAL: The 'finally' block ensures the dialog closes
      // whether the 'try' succeeded OR the 'catch' caught an error.
      if (mounted && Navigator.canPop(context)) {
        // Use rootNavigator: true if the dialog was opened on the root navigator
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void resetMap() {
    setState(() {
      polylineCoordinates.clear();
      polylinesSet.clear();
      _markers.clear();
      _circles.clear();
      rideBannerHeight = 0;
      searchBannerHeight = Platform.isIOS ? 300 : 290;
      mapBottomPadding = Platform.isIOS ? 300 : 260;
      isDrawerOpen = true;
    });
    _userCurrentPosition();
  }
}
