class PersonCheckPointDto {
  int id;
  int personId;
  int sessionId;
  int checkPointId;
  String lastname;
  String? firstname;

  PersonCheckPointDto({required this.personId, required this.sessionId, required this.checkPointId, required this.lastname, required this.firstname, required this.id});
}