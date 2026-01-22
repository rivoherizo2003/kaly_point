class EditSessionDto {
  final int id;
  final String title; // TM 2026
  final String? description;

  EditSessionDto({
    required this.id,
    required this.title,
    this.description
  });


  // Factory constructor for creating from JSON
  factory EditSessionDto.fromMap(Map<String, dynamic> json) {
    return EditSessionDto(
      id: json['id'],
      title: json['title'],
      description: json['description'] != null ? json["description"] : null,
    );
  }
}
