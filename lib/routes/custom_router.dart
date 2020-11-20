import 'package:flutter/material.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/ui/pages/home_page.dart';
import 'package:turrant/ui/pages/about_page.dart';

class CustomRouter {

  static Route<dynamic> allRoutes(RouteSettings routeSettings,) {
    switch(routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutPage());

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}