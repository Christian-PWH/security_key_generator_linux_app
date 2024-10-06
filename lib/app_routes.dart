import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:security_key_generator/home_screen.dart';

class AppRoutes {
  static const homeScreen = "/home-screen";

  static const createKeyScreen = "/create-key-screen";
}

Route<dynamic> generateRoute(RouteSettings routeSetting) {
  switch (routeSetting.name) {
    default:
      return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 300));
  }
}
