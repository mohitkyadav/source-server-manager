import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/routes/route_names.dart';

class HomeDrawerList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  child: Icon(
                    Icons.home_filled,
                    size: 100,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: Text(AppLocalizations.of(context)
                    .getTranslatedValue('drawer_settings_btn_txt')),
                onTap: () => Navigator.pushNamed(context, settingsRoute),
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                ),
                title: Text(AppLocalizations.of(context)
                    .getTranslatedValue('drawer_about_btn_txt')),
                onTap: () => Navigator.pushNamed(context, aboutRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
