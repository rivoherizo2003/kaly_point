class Session {
  int id;
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;

  Session({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['created_at']),
      description: map['description'] != null ? map["description"] : null,
    );
  }
}
