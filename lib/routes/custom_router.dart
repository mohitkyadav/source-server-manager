import 'package:flutter/material.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/ui/pages/home/home_page.dart';
import 'package:turrant/ui/pages/about/about_page.dart';
import 'package:turrant/ui/pages/settings/settings_page.dart';
import 'package:turrant/ui/pages/add_server/add_server.dart';

class CustomRouter {

  static Route<dynamic> allRoutes(RouteSettings routeSettings,) {
    switch(routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());

      case aboutRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => AboutPage());

      case settingsRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const SettingsPage());

      case addServerRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const AddServerPage());

      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
    }
  }
}
