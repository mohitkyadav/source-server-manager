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

      final String name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
      final List<String> split = line.split('"')[2]
          .trim().replaceAll('  ', ' ').split(' ');

      final String steamId = parseSteam64Id(split[0]);
      final String time = split[1];
      final String ping = split[2];
      final String score = split[3];

      playersOnSv.add(Player(name, score, time, ping, steamId));
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
}
