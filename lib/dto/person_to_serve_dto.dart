class PersonToServeDto {
  int personId;
  int checkPointId;
  String lastname;
  String? firstname;

  PersonToServeDto({required this.personId, required this.checkPointId, required this.lastname, required this.firstname});


  
  factory PersonToServeDto.fromMap(Map<String, dynamic> map){
    return PersonToServeDto(personId: map['person_id'], lastname: map['lastname'], firstname: map['firstname'], checkPointId: map['check_point_id']);
  }
}