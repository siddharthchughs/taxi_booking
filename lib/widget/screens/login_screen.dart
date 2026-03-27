import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_booking/services/init_getit.dart';
import 'package:taxi_booking/services/navigation/navigation_service.dart';
import 'package:taxi_booking/widget/custom_progressbar.dart';
import 'package:taxi_booking/widget/screens/home_screen.dart';
import 'package:taxi_booking/widget/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  double? _deviceWidth, _deviceHeight;
  final _formKey = GlobalKey<FormState>();
  var userNameState;
  var userPasswordState;
  String loggedInUser = "";
  bool isLoading = false;
  bool isTextObsecure = true;
  String isConnected = 'Unknown';
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final _fireBaseAuth = FirebaseAuth.instance;
  final _signUpFormKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _focusNode = FocusNode();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      updateConnectionStatus,
    );
  }

  Future<void> loginUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
      showDialog(
        context: context,
        builder: (context) {
          return CustomProgressbar(status: 'Logging In..');
        },
      );
    });

    try {
      final userValid = await _fireBaseAuth.signInWithEmailAndPassword(
        email: userNameState,
        password: userPasswordState,
      );

      final userReference = FirebaseDatabase.instance.ref().child(
        'users/${userValid.user!.uid}',
      );
      if (!mounted) return;
      final snapshot = await userReference.get();
      if (snapshot.exists && snapshot.value != null) {
        getIt<NavigationService>().navigateRemoveUntil(MyRideScreen());
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication Falied')),
      );
      Navigator.pop(context);
    } finally {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
            color: Colors.white,
            child: loginForm(),
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          logoImage(),
          const SizedBox(height: 30),
          loginUserInputField(),
          const SizedBox(height: 15),
          loginPasswordInputField(),
          const SizedBox(height: 30),
          loginButton(),
          const SizedBox(height: 20),
          navigateToSignUp(),
        ],
      ),
    );
  }

  Widget logoImage() {
    return Image.asset(
      'images/logo.png',
      width: 180.0,
      height: 180.0,
      fit: BoxFit.contain,
    );
  }

  Widget loginUserInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (newUpdatedValue) {
        // 1. check if the  _newUpdatedValue is null || empty

        if (newUpdatedValue == null || newUpdatedValue.isEmpty) {
          return 'Please enter an email address';
        }
        // 2. followed to this _newUpdatedValue has Regex.hasmatch()

        final emailValidFormat = RegExp(
          ''
          r'^[\w-\.]+@([\w-]+\.com)+[\w-]{2,4}$',
        );
        if (!emailValidFormat.hasMatch(newUpdatedValue)) {
          return 'Please enter the email in valid format';
        }
        return null;
      },
      onSaved: (updateUsername) {
        userNameState = updateUsername!;
      },
      onChanged: (value) {
        userNameState = value;
      },
    );
  }

  Widget loginPasswordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(fontSize: 16),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isTextObsecure = !isTextObsecure;
            });
          },
          icon: Icon(
            isTextObsecure ? Icons.visibility_off : Icons.visibility,
            color: Colors.blueAccent.shade400,
          ),
        ),
      ),
      obscureText: isTextObsecure,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,

      validator: (updatePasswordValue) {
        // 1. check if the  _updatePasswordValue is null || empty

        if (updatePasswordValue == null || updatePasswordValue.isEmpty) {
          return 'Please enter your password';
        }
        // 2. followed to this _updatePasswordValue has length > 0

        if (updatePasswordValue.length < 3) {
          return 'Password must be greater than 3 characters';
        }

        //3. followed to this _updatePasswordValue has to have one Uppercase

        final passwordValidAlphabetFormat = RegExp(r'[A-Z]');
        if (!updatePasswordValue.contains(passwordValidAlphabetFormat)) {
          return 'Must have atleast one Uppercase letter';
        }

        //4. // followed to this _updatePasswordValue has to have one digit atleast

        final passwordValidNumberFormat = RegExp(r'[0-9]');
        if (!updatePasswordValue.contains(passwordValidNumberFormat)) {
          return 'Must have atleast one digit atleast';
        }
        //5. returns null if the _updatePasswordValue is valid.

        return null;
      },

      // passwordState is saved over here !
      onSaved: (updatePasswordTextState) {
        userPasswordState = updatePasswordTextState!;
      },
    );
  }

  void initConnectivity() async {
    List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
    try {
      connectionStatus = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return updateConnectionStatus(connectionStatus);
  }

  Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (result.contains(ConnectivityResult.wifi)) {
        isConnected = 'WiFi';
      } else if (result.contains(ConnectivityResult.mobile)) {
        isConnected = 'Mobile';
      } else if (result.contains(ConnectivityResult.none)) {
        isConnected = 'No Connection';
      } else {
        isConnected = 'Failed to get connectivity.';
      }
    });
  }

  // void initConnectivity() async {
  //   ConnectivityResult result = ConnectivityResult.none;
  //   try {
  //     result = await connect.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return updateConnectionStatus(result);
  // }

  // Future<void> updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //     case ConnectivityResult.mobile:
  //     case ConnectivityResult.none:
  //       setState(() => isConnected = result.toString());
  //       break;
  //     default:
  //       setState(() => isConnected = 'Failed to get connectivity.');
  //       break;
  //   }
  // }

  Widget loginButton() {
    return MaterialButton(
      onPressed: loginUser,
      minWidth: _deviceWidth!,
      height: 45,
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      textColor: Colors.blueAccent.shade400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.blueAccent.shade400),
      ),
      child: Text(
        'Submit',
        style: TextStyle(
          fontFamily: 'Brand-Regular',
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget navigateToSignUp() {
    return MaterialButton(
      onPressed: () {
        getIt<NavigationService>().navigateTo(SignUpScreen());
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.white),
      ),
      child: Text(
        'SignUp',
        style: TextStyle(
          fontFamily: 'Brand-Regular',
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }
}
