import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/check_point.dart';

class Person {
  final int id;
  final String lastname;
  final String? firstname;
  final DateTime createdAt;

  Person({
    required this.id,
    required this.lastname,
    this.firstname,
    required this.createdAt,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      lastname: map['lastname'],
      createdAt: DateTime.parse(map['created_at']),
      firstname: map['firstname'],
    );
  }

  static bool isNotInSession(
    PersonCheckPointDto personCheckPointDto
  ) => personCheckPointDto.personSessionId == null;

  static bool inSessionNotServed(
    PersonCheckPointDto personCheckPointDto,
    CheckPoint currentCheckPoint,
  ) =>
      personCheckPointDto.checkPointPersonId == null &&
      personCheckPointDto.currentSessionId == currentCheckPoint.sessionId;

  static bool inSessionAndServed(
    PersonCheckPointDto personCheckPointDto,
    CheckPoint currentCheckPoint,
  ) =>
      personCheckPointDto.checkPointPersonId != null &&
      personCheckPointDto.currentSessionId == currentCheckPoint.sessionId;
}
