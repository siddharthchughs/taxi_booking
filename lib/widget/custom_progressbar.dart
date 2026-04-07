import 'package:flutter/material.dart';

class CustomProgressbar extends StatelessWidget {
  const CustomProgressbar({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8.0),
      ),
      backgroundColor: Colors.lightBlue.shade300,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        height: 80.0,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            SizedBox(width: 12.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade100),
            ),
            SizedBox(width: 20.0),
            Text(status),
          ],
        ),
      ),
    );
  }
}
