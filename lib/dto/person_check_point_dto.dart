class PersonCheckPointDto {
  int personId;
  int? checkPointId;
  int? currentSessionId;
  int? checkPointPersonId;
  int? personSessionId;
  String lastname;
  String? firstname;

  PersonCheckPointDto({
    required this.personId,
    this.checkPointId,
    this.currentSessionId,
    this.checkPointPersonId,
    this.personSessionId,
    required this.lastname,
    this.firstname,
  });

  factory PersonCheckPointDto.fromMap(Map<String, dynamic> map) {
    return PersonCheckPointDto(
      checkPointPersonId: map['check_point_person_id'],
      personId: map['person_id'],
      lastname: map['lastname'],
      firstname: map['firstname'],
      checkPointId: map['check_point_id'],
      currentSessionId: map['current_session_id'],
      personSessionId: map['session_person_id']
    );
  }
}
