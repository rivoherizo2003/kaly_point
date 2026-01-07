class Session {
  int? id;
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;

  Session({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['createdAt']),
      description: map['description'] != null ? map["description"] : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
    };
  }
}
