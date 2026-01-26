class PersonSessionDto{
  int personId;
  int sessionId;
  String lastname;
  String? firstname;

  PersonSessionDto({required this.personId, required this.sessionId, required this.lastname, required this.firstname});
}