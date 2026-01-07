class EditSession {
  final int id;
  final String title; // TM 2026
  final String? description;

  EditSession({
    required this.id,
    required this.title,
    this.description
  });


  // Factory constructor for creating from JSON
  factory EditSession.fromMap(Map<String, dynamic> json) {
    return EditSession(
      id: json['id'],
      title: json['title'],
      description: json['description'] != null ? json["description"] : null,
    );
  }
}
