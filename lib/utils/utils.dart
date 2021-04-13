import 'package:turrant/models/player.dart';

class Utils {
  static List<Player> parseStatus(String statusRes) {
    final String status = statusRes.trim();
    final List<String> lines = status.split('\n');
    final int index = lines.indexWhere((String line) => line.startsWith('#'));

    return _parseUsers(lines.sublist(index + 1, lines.length - 1));
  }

  static List<Player> _parseUsers(List<String> playerStrings) {
    final List<Player> playersOnSv = <Player>[];

    for (final String line in playerStrings) {
      if (line.startsWith('#end')) {
        break;
      }

      final String name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
      final List<String> split = line.split(' ');
      final String steamId = _parseSteam64Id(split[5]);
      final String time = split[6];
      final String ping = split[7];
      final String score = split[8];

      playersOnSv.add(Player(name, score, time, ping, steamId));
    }

    return playersOnSv;
  }

  static String _parseSteam64Id(String steamId) {
    return ((int.parse(steamId.split(':')[2]) * 2) + 76561197960265728)
        .toString();
  }
}
