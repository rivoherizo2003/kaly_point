class PersonCheckPointDto {
  int id;
  int personId;
  int checkPointId;
  String lastname;
  String? firstname;

  PersonCheckPointDto({required this.personId, required this.checkPointId, required this.lastname, required this.firstname, required this.id});


  
  factory PersonCheckPointDto.fromMap(Map<String, dynamic> map){
    return PersonCheckPointDto(id: map['check_point_person_id'],personId: map['person_id'], lastname: map['lastname'], firstname: map['firstname'], checkPointId: map['check_point_id']);
  }
}