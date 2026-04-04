import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/model/search_place_model.dart';
import 'package:taxi_booking/services/network/network_request_result.dart';
import 'package:taxi_booking/viewmodel/location_provider.dart';
import 'package:taxi_booking/widget/predictions_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  var _currentLocationState;
  var _destinationState = '';
  final searchLocationKey = GlobalKey<FormState>();
  final FocusNode searchLocationFocusNode = FocusNode();
  List<SearchPlaceModel> _predictions = [];
  bool isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void setFocusTODestination() {
    if (!isLocationEnabled) {
      FocusScope.of(context).requestFocus(searchLocationFocusNode);
    }
    isLocationEnabled = true;
  }

  void searchLocation(String destination) async {
    final isValid = searchLocationKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    searchLocationKey.currentState!.save();
    _destinationState = destination;
    if (_currentLocationState != null || _destinationState.isNotEmpty) {
      if (!mounted) return;
      final response = await NetworkRequestResult().searchPlaces(
        _destinationState,
        context,
      );
      setState(() {
        _predictions = response;
      });
    }
  }

  void searchPlaceByID(String placeId, context) async {
    if (placeId.isNotEmpty) {
      await NetworkRequestResult().placeInfo(placeId, context);
    } else {
      Future.error('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocusTODestination();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue.shade400),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          title: Text('Where to go?'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(4),
                  right: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 4, 12.0, 4),
                child: _searchLocationForm(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: (_predictions.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _predictions.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: _predictions[index],
                            child: PredictionItemWidget(),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Text('No record found !'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchLocationForm() {
    return Form(
      key: searchLocationKey,
      child: Column(
        children: [
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              _iconLocation(Icons.my_location_rounded, Colors.green),
              SizedBox(width: 12),
              Expanded(child: _locationInputField()),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              _iconLocation(Icons.location_on_outlined, Colors.blueAccent),
              SizedBox(width: 8),
              Expanded(child: _destinationLocationInputField()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconLocation(IconData iconData, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4),
          bottom: Radius.circular(4),
        ),
      ),
      child: Icon(iconData, color: color),
    );
  }

  Widget _locationInputField() {
    return Consumer(
      builder: (context, LocationProvider locationProvider, child) {
        return TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            ),
            filled: false,
            contentPadding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            hintText: 'Your Current Location',
            hintStyle: TextStyle(fontSize: 14),
          ),
          initialValue: locationProvider.pickAddress?.formattedAddres,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          validator: (updatedCurrentLocationValue) {
            if (updatedCurrentLocationValue == null ||
                updatedCurrentLocationValue.isEmpty ||
                updatedCurrentLocationValue.trim().length < 0) {
              return 'Please enter your current location';
            }
            return null;
          },
          onSaved: (savedCurrentLocation) {
            _currentLocationState = savedCurrentLocation!;
          },
        );
      },
    );
  }

  Widget _destinationLocationInputField() {
    return TextFormField(
      showCursor: true,
      cursorColor: Colors.blueAccent,
      cursorWidth: 2,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
        filled: false,
        contentPadding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        prefixStyle: TextStyle(backgroundColor: Colors.orangeAccent),
        hintText: 'Your Destination Location',
        hintStyle: TextStyle(fontSize: 14),
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      validator: (updatedDestinationLocationValue) {
        if (updatedDestinationLocationValue == null ||
            updatedDestinationLocationValue.isEmpty ||
            updatedDestinationLocationValue.trim().length < 0) {
          return 'Please enter your destination location';
        }
        return null;
      },
      onSaved: (savedDestinationLocation) {
        _destinationState = savedDestinationLocation!;
      },
      onChanged: (value) {
        _destinationState = value;
        searchLocation(_destinationState);
      },
    );
  }

  @override
  void dispose() {
    searchLocationFocusNode.dispose();
    super.dispose();
  }
}
