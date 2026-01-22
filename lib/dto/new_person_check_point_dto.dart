class NewPersonCheckPointDto {
  int personId;
  int sessionId;
  int checkPointId;
  DateTime createdAt;

  NewPersonCheckPointDto({required this.personId, required this.sessionId, required this.checkPointId, required this.createdAt});
}