class AddSession {
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;

  AddSession({
    required this.title,
    this.description,
    required this.createdAt,
  });
}
