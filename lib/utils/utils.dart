import 'package:turrant/models/player.dart';

class Utils {
  static List<Player> parseStatus(String statusRes) {
    final String status = statusRes.trim();
    final List<String> lines = status.split('\n');
    final int index = lines.indexWhere((String line) => line.startsWith('#'));

    return parseUsers(lines.sublist(index + 1, lines.length - 1));
  }

  static List<Player> parseUsers(List<String> playerStrings) {
    final List<Player> playersOnSv = <Player>[];

    for (final String line in playerStrings) {
      if (line.startsWith('#end')) {
        break;
      }

      // Dont count GOTV as a player
      if (line.contains('GOTV')) {
        continue;
      }

      final String name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
      final List<String> split = line.split('"')[2]
          .trim().replaceAll('  ', ' ').split(' ');

      final String steamId = split[0];
      final String id = parseSteam64Id(steamId);
      final String time = split[1];
      final String ping = split[2];
      final String score = split[3];

      playersOnSv.add(Player(name, score, time, ping, id, steamId));
    }

    return playersOnSv;
  }

  static String parseSteam64Id(String steamId) {
    if(!steamId.startsWith('STEAM_')) {
      return '';
    }

    return ((int.parse(steamId.split(':')[2]) * 2) + 76561197960265728)
        .toString();
  }

  static List<String> parseMaps(String maps) {
    final List<String> mapStrings = maps.replaceAll(
        RegExp('[ ][ ]'), '').split('\n');

    final List<String> mapsResponse = <String>[];
    for (final String mapString in mapStrings) {
      if (mapString.contains('.bsp') && !mapString.contains('workshop')) {
        mapsResponse.add(mapString.split('.bsp')[0].split(' ')[2]);
      }
    }

    return mapsResponse;
  }
}
