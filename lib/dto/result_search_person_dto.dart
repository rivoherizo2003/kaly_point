class ResultSearchPersonDto {
  int idPerson;
  bool isServed;
  int checkPointId;
  int sessionId;
  int checkPointPersonId;
  String lastname;
  String? firstname;

  ResultSearchPersonDto({required this.idPerson, required this.isServed, required this.checkPointId, required this.sessionId, required this.checkPointPersonId, required this.lastname, this.firstname});
}