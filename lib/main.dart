import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/firebase_options.dart';
import 'package:taxi_booking/provider/location_provider.dart';
import 'package:taxi_booking/services/init_getit.dart';
import 'package:taxi_booking/services/navigation/navigation_service.dart';
import 'package:taxi_booking/widget/screens/home_screen.dart';

void main() async {
  setUplocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {});
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: MaterialApp(
        navigatorKey: getIt<NavigationService>().navigationKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Brand-Bold',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: MyRideScreen(),
      ),
    );
  }
}
