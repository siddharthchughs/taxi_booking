// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class NetworkConnectivityResult {
//   final Connectivity _connectivity = Connectivity();

//   NetworkConnectivityResult() {
//     List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
//     late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
//       updateConnectionStatus,
//     );
//   }

//   void initConnectivity() async {
//     List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
//     try {
//       connectionStatus = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//     if (!mounted) {
//       return Future.value(null);
//     }
//     return updateConnectionStatus(connectionStatus);
//   }

//   Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
//     switch(result){
//       'wifi"
//     }
//       _connectionStatus = result;
//       if (result.contains(ConnectivityResult.wifi)) {
//         isConnected = 'WiFi';
//       } else if (result.contains(ConnectivityResult.mobile)) {
//         isConnected = 'Mobile';
//       } else if (result.contains(ConnectivityResult.none)) {
//         isConnected = 'No Connection';
//       } else {
//         isConnected = 'Failed to get connectivity.';
//       }
//     }
//   }
// }
