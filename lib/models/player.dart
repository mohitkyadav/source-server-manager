class Player {
  Player(this.name, this.score, this.duration, this.ping, this.id);

  String name;
  String score;
  String duration;
  String ping;
  String id;

  @override
  String toString() {
    return name;
  }

  Map<String, String> toJson() => <String, String> {
    'name': name,
    'score': score,
    'duration': duration,
    'id': id,
    'ping': ping,
  };

  static Player fromJson(Map<String, dynamic> json) => Player(
    json['name'].toString(), json['score'].toString(),
    json['duration'].toString(), json['id'].toString(),
    json['ping'].toString()
  );
}
