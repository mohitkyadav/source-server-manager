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
