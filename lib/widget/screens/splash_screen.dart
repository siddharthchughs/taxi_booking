import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key, required this.title});

  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: MaterialButton(
          minWidth: 200,
          height: 48,
          color: Colors.amber.shade500,
          onPressed: () {
            DatabaseReference fd = FirebaseDatabase.instance.ref().child(
              'Test',
            );
            fd.set('isConnected');
          },
          child: Text('Click me'),
        ),
      ),
    );
  }
}
