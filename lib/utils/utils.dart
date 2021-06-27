import 'package:turrant/models/player.dart';

class Utils {
  static List<Player> parseStatus(String statusRes, String playersWithPower) {
    final String status = statusRes.trim();
    final List<String> linesStatus = status.split('\n');
    final List<String> linesPlayers = playersWithPower.split('\n');
    final int rightIdx = linesPlayers
        .indexWhere((String line) => line.trim().startsWith('1.'));
    final int index = linesStatus
        .indexWhere((String line) => line.startsWith('#'));

    return parseUsers(
        linesStatus.sublist(index + 1, linesStatus.length - 1),
        rightIdx > 0
            ? linesPlayers.sublist(rightIdx, linesPlayers.length - 1)
            : <String>[],
    );
  }

  static List<Player> parseUsers(List<String> playerStrings,
      List<String> powerStrings) {
    final List<Player> playersOnSv = <Player>[];

    final Map<String, String> accessLevelMap = Map<String, String>.fromEntries(
        powerStrings.map((String line) {

          final List<String> splitFromIndex = line.trim().split('.');
          final List<String> splitNameFromAcc = removeEmptyItems(
              splitFromIndex[1].trim().split('  '));
          final List<String> restString = splitNameFromAcc.length > 1
              ? splitNameFromAcc.sublist(1, splitNameFromAcc.length)
              : <String>[];

          return MapEntry<String, String>(
              splitNameFromAcc.length > 1 ? splitNameFromAcc[0] : '',
              restString.join(','));
        }));

    for (final String line in playerStrings) {
      if (line.startsWith('#end')) {
        break;
      }

      // get name of the player
      final String name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
      final List<String> split = line.split('"')[2]
          .trim().replaceAll('  ', ' ').split(' ');

      // Skip bots and GOTV
      if (split.length < 5) {
        continue;
      }

      final String steamId = split[0];
      final String id = parseSteam64Id(steamId);
      final String time = split[1];
      final String ping = split[2];
      final String score = split[3];
      final String timesConnected = line.split('"')[0].split(' ')[2].trim();

      playersOnSv.add(Player(name, score, time, ping,
          id, steamId, accessLevelMap[name], timesConnected));
    }

    return playersOnSv;
  }

  static String parseSteam64Id(String steamId) {
    if(!steamId.startsWith('STEAM_')) {
      return '';
    }

    final int steam64Id = ((int.parse(steamId.split(':')[2]) * 2)
        + 76561197960265728) | int.parse(steamId.split(':')[1]);

    return steam64Id.toString();
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

  static List<String> removeEmptyItems(List<String> list) {
    if (list == null) {
      return <String>[];
    }

    return list.where((String string) => string.isNotEmpty).toList();
  }
}
