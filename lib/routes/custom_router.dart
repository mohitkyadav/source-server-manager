import 'package:flutter/material.dart';
import 'package:turrant/models/server.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/ui/pages/home/home_page.dart';
import 'package:turrant/ui/pages/about/about_page.dart';
import 'package:turrant/ui/pages/server_details/server_details.dart';
import 'package:turrant/ui/pages/settings/settings_page.dart';
import 'package:turrant/ui/pages/add_server/add_server.dart';

class CustomRouter {

  static Route<dynamic> allRoutes(RouteSettings routeSettings,) {
    switch(routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());

      case aboutRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const AboutPage());

      case settingsRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const SettingsPage());

      case addServerRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const AddServerPage());

      case serverDetailsRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => ServerDetailsPage(
                routeSettings.arguments as Server));

      default:
        return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
    }
  }
}
