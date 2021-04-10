class Player {
  Player(this.name, this.score, this.duration);

  String name;
  String score;
  String duration;

  @override
  String toString() {
    return name;
  }

  Map<String, String> toJson() => <String, String> {
    'name': name,
    'score': score,
    'duration': duration,
  };

  static Player fromJson(Map<String, dynamic> json) => Player(
    json['name'].toString(), json['score'].toString(),
    json['duration'].toString()
  );
}
