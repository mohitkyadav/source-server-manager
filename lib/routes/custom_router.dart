import 'package:flutter/material.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/ui/pages/home/home_page.dart';
import 'package:turrant/ui/pages/about/about_page.dart';
import 'package:turrant/ui/pages/settings/settings_page.dart';

class CustomRouter {

  static Route<dynamic> allRoutes(RouteSettings routeSettings,) {
    switch(routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutPage());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsPage());

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}