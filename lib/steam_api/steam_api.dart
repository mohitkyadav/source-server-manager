import 'dart:convert';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getPlayerDetails(String id) async {

  final http.Response response = await http.get(
      Uri.parse('https://steamcommunity.com/profiles/$id/?xml=1'));
  if (response.statusCode == 200) {
    final Xml2Json parser = Xml2Json();
    parser.parse(response.body);

    return jsonDecode(parser.toParker());
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}

Future<dynamic> checkForSvUpdate(String? ver) async {

  final http.Response response = await http.get(
      Uri.parse('http://api.steampowered.com/ISteamApps/UpToDateCheck/v0001/'
          '?appid=730&version=$ver&format=json'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}
