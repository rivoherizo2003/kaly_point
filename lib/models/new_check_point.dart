class NewCheckPoint {
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;
  final int sessionId;

  NewCheckPoint({
    required this.title,
    this.description,
    required this.createdAt,
    required this.sessionId
  });
}