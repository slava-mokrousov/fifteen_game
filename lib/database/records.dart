import 'dart:convert';

Record recordFromJson(String str) {
  final jsonData = json.decode(str);
  return Record.fromMap(jsonData);
}

String recordToJson(Record data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Record {
  int moves;

  Record({
    this.moves,
  });

  factory Record.fromMap(Map<String, dynamic> json) => new Record(
    moves: json["moves"],
  );

  Map<String, dynamic> toMap() => {
    "moves": moves,
  };

  int getMoves() {
    return moves;
  }
}