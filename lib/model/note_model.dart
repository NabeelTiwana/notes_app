class NoteModel {
  int? id;
  String title;
  String body;
  DateTime creation_date;

  NoteModel({
    this.id,
    required this.title,
    required this.body,
    required this.creation_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'creation_date': creation_date.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      creation_date: DateTime.parse(map['creation_date']),
    );
  }
}
