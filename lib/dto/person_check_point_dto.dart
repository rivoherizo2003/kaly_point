class PersonCheckPointDto {
  final int personId;
  final int? checkPointId;
  final int? currentSessionId;
  final int? checkPointPersonId;
  final int? personSessionId;
  final String lastname;
  final String? firstname;

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
      checkPointPersonId: map['check_point_person_id'] as int?,
      personId: map['person_id'] as int,
      lastname: map['lastname'] as String,
      firstname: map['firstname'] as String?,
      checkPointId: map['check_point_id'] as int?,
      currentSessionId: map['current_session_id'] as int?,
      personSessionId: map['session_person_id'] as int?,
    );
  }
}