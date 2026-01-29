class Person {
  int id;
  String lastname;
  String? firstname;
  DateTime createdAt;

  Person({required this.id,required this.lastname, this.firstname, required this.createdAt});

  factory Person.fromMap(Map<String, dynamic> map){
    return Person(id: map['id'], lastname: map['lastname'], createdAt: DateTime.parse(map['created_at']), firstname: map['firstname']);
  }
}