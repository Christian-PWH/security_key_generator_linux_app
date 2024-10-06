import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:security_key_generator/create_key_screen.dart';
import 'package:security_key_generator/home_screen.dart';

class AppRoutes {
  static const homeScreen = "/home-screen";

  static const createKeyScreen = "/create-key-screen";
}

Route<dynamic> generateRoute(RouteSettings routeSetting) {
  switch (routeSetting.name) {
    case AppRoutes.createKeyScreen:
      final selectedDrive = routeSetting.arguments as String;
      return PageTransition(
          child: CreateKeyScreen(selectedDrive: selectedDrive),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 300));
    default:
      return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 300));
  }
}
