// lib/routes.dart
import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/calculator_page.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String calculator = '/calculator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case calculator:
        return MaterialPageRoute(builder: (_) => CalculatorPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
