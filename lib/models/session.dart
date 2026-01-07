class Session {
  final String id;
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;
  final DateTime? updatedAt;

  Session({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      description: json['description'] !=null ? json["description"]: null
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'description': description
    };
  }
}
