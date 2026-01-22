class EditCheckPointDto {
  int id;
  final String title;
  final String? description;

  EditCheckPointDto({
    required this.id,
    required this.title,
    this.description,
  });
}