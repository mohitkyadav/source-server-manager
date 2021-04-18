import 'package:flutter/material.dart';
import 'package:turrant/models/server.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/ui/pages/pages.dart';

class CustomRouter {

  static Route<dynamic> allRoutes(RouteSettings routeSettings,) {
    switch(routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());

      case aboutRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const AboutPage());

      case settingsRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const SettingsPage());

      case serverDetailsRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => ServerDetailsPage(
                routeSettings.arguments as Server));

      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
    }
  }
}
