import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/models.dart';
import 'package:turrant/routes/route_names.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/ui/pages/pages.dart';
import 'package:turrant/ui/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Server> servers = <Server>[];
  Server _currentServer;

  @override
  void initState() {
    super.initState();
    _getServers();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = AppLocalizations.of(context)
        .getTranslatedValue('app_bar_title');

    final bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    if (!isSmallScreen) {
      return _buildLargeScreenLayout(context, _title);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(context, _title),
          ServersList(servers, _removeServer,
              _handleSvLongPress, _setSelectedServer),
        ],
      ),
      floatingActionButton: addSvFab(context),
    );
  }

  Widget _buildLargeScreenLayout (BuildContext context, String _title) {

    return Scaffold(
      body: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: CustomScrollView(
              slivers: <Widget>[
                _buildAppBar(context, _title),
                ServersList(servers, _removeServer,
                    _handleSvLongPress, _setSelectedServer),
              ],
            ),
          ),
          if (_currentServer != null) Expanded(
            child: ServerDetailsPage(_currentServer),
          ),
        ],
      ),
      floatingActionButton: addSvFab(context),
    );
  }

  Widget _buildAppBar (BuildContext context, String _title) {
    return
      SliverAppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(_title, style: AppStyles.appBarTitle,),
        ),
        centerTitle: false,
        expandedHeight: 120,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('${servers.length} Servers',
            style: AppStyles.appBarSubTitle,),
          titlePadding: const EdgeInsets.all(20),
        ),
        collapsedHeight: 80,
        floating: true,
        pinned: true,
        actions: <Widget>[
          CircleButton(const Icon(Icons.settings, size: 18,), () {
            Navigator.of(context).pushNamed(settingsRoute);
          }),
        ],
      );
  }

  void _setSelectedServer (Server server) {
    setState(() {
      _currentServer = server;
    });
  }

  Widget addSvFab(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<Widget>(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            builder: (BuildContext context) => Container(
              child: AddServerForm(refreshServers: _getServers,),
            ));
        // Navigator.pushNamed(context, addServerRoute);
      },
    );
  }

  void _handleSvLongPress(Server sv) {
    showModalBottomSheet<Widget>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) => Container(
        child: AddServerForm(refreshServers: _getServers, sv: sv,),
      )
    );
  }

  Future<void> _getServers() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      final List<Server> currentServers = currentAddedServers.map((String server) => Server
          .fromJson(jsonDecode(server) as Map<String, dynamic>)
      ).toList();

      setState(() {
        servers = currentServers;
      });
    });
  }

  Future<void> _removeServer(Server serverToRemove) {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      final List<String> filteredSv = <String>[];
      final List<Server> filteredServerObjects = <Server>[];

      currentAddedServers.forEach((String svString) {
        final Server svObject = Server
            .fromJson(jsonDecode(svString) as Map<String, dynamic>);

        if (serverToRemove.serverIp != svObject.serverIp
            || serverToRemove.serverRcon != svObject.serverRcon
            || serverToRemove.serverName != svObject.serverName) {
          filteredSv.add(svString);
          filteredServerObjects.add(svObject);
        }
      });

      setState(() {
        servers = filteredServerObjects;
      });

      prefs.setStringList('addedServers', filteredSv);
    });
  }
}
