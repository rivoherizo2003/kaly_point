class NewPersonDto {
  String lastname;
  String? firstname;
  DateTime createdAt;

  NewPersonDto({required this.lastname, this.firstname, required this.createdAt});
}
