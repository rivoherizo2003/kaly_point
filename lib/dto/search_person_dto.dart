class SearchPersonDto {
  final int personId;
  final String lastname;
  final String? firstname;
  final int? sessionId;
  final int? checkPointId;
  final int? checkPointPersonId;


  SearchPersonDto({required this.personId, required this.lastname, this.firstname, this.sessionId, this.checkPointId, this.checkPointPersonId});

  factory SearchPersonDto.fromMap(Map<String, dynamic> map){
    return SearchPersonDto(personId: map['id'], lastname: map['lastname'], firstname: map['firstname'], sessionId: map['session_id'], checkPointId: map['check_point_id'], checkPointPersonId: map['check_point_person_id']);
  }
}