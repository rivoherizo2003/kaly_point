class CheckPoint {
  int id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final int sessionId;

  CheckPoint({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.sessionId
  });

  factory CheckPoint.fromMap(Map<String, dynamic> map) {
    return CheckPoint(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['created_at']),
      description: map['description'],
      sessionId: map['session_id']
    );
  }
}
