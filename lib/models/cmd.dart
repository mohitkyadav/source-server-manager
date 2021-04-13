class Command {
  Command(this.cmdText, this.isResponse,);

  String cmdText;
  bool isResponse;

  @override
  String toString() {
    return cmdText;
  }

  Map<String, String> toJson() => <String, String> {
    'cmdText': cmdText,
    'isResponse': isResponse.toString(),
  };

  static Command fromJson(Map<String, dynamic> json) => Command(
    json['cmdText'].toString(), json['isResponse'].toLowerCase() == 'true',
  );
}
