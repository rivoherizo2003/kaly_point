class CheckPoint {
  int id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final int sessionId;
  int nbrPersonServed;

  CheckPoint({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.sessionId,
    this.nbrPersonServed = 0,
  });

  factory CheckPoint.fromMap(Map<String, dynamic> map) {
    return CheckPoint(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['created_at']),
      description: map['description'],
      sessionId: map['session_id'],
      nbrPersonServed: map['nbr_person_served'] ?? 0,
    );
  }
}
