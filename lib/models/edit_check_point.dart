class EditCheckPoint {
  int id;
  final String title;
  final String? description;

  EditCheckPoint({
    required this.id,
    required this.title,
    this.description,
  });
}