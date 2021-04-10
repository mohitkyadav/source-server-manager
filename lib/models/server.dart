class Server {
  Server(this.serverName, this.serverIp, this.serverPort, this.serverRcon,
      this.serverGame);

  String serverName;
  String serverIp;
  String serverPort;
  String serverRcon;
  String serverGame;

  @override
  String toString() {
    return serverName;
  }

  Map<String, String> toJson() => <String, String> {
    'serverName': serverName,
    'serverIp': serverIp,
    'serverPort': serverPort,
    'serverRcon': serverRcon,
    'serverGame': serverGame,
  };

  static Server fromJson(Map<String, String> json) => Server(
    json['serverName'], json['serverName'], json['serverName'],
    json['serverName'], json['serverName']
  );
}
