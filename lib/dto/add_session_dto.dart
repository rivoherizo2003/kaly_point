class AddSessionDto {
  final String title; // TM 2026
  final String? description; // Fort dauphin (destination)
  final DateTime createdAt;

  AddSessionDto({
    required this.title,
    this.description,
    required this.createdAt,
  });
}
