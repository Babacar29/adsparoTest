import 'package:adsparo_test/ui/screens/SetUpProfile/setUpProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/screens/HomePage/HomePage.dart';
import '../ui/screens/auth/ForgotPassword.dart';
import '../ui/screens/auth/loginScreen.dart';
import '../ui/screens/introSlider.dart';
import '../ui/screens/splashScreen.dart';

class Routes {
  static const String splash = "splash";
  static const String home = "/home";
  static const String introSlider = "introSlider";
  static const String login = "login";
  static const String forgotPass = "forgotPass";
  static const String setUpProfile = "/editUserProfile";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    switch (routeSettings.name) {
      case splash:
        {
          return CupertinoPageRoute(builder: (_) => const Splash());
        }
      case introSlider:
        {
          return CupertinoPageRoute(builder: (_) => const IntroSliderScreen());
        }
      case home:
        {
          return HomeScreen.route(routeSettings);
        }
      case setUpProfile:
        {
          return SetUpProfile.route(routeSettings);
        }
      case login:
        {
          return LoginScreen.route(routeSettings);
        }
      case forgotPass:
        {
          return CupertinoPageRoute(builder: (_) => const ForgotPassword());
        }
      default:
        {
          return CupertinoPageRoute(builder: (context) => const Scaffold());
        }
    }
  }
}
