import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigationKey;

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic>? navigateTo(Widget widget) {
    return navigationKey.currentState?.push(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }

  Future<dynamic>? navigateWithArgument(Widget widget, String argument) {
    return navigationKey.currentState?.push(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }

  Future<dynamic>? navigateRemoveUntil(Widget widget) {
    return navigationKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );
  }
}
