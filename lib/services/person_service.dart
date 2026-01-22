import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/models/person.dart';
import 'package:kaly_point/services/database_service.dart';

class PersonService{
  final _databaseService = DatabaseService();

  Future<Person> insertPerson(NewPersonDto newPerson) async {
    final db = await _databaseService.database;
    try {
      final id = await db.insert('check_point_person', {
        'lastname': newPerson.lastname,
        'firstname':newPerson.firstname,
        'created_at': newPerson.createdAt.toIso8601String(),
      });

      return Person(id: id, lastname: newPerson.lastname,firstname: newPerson.firstname, createdAt: newPerson.createdAt);
    } catch (error) {
      throw Exception("Failed to insert person: $error");
    }
  }
}