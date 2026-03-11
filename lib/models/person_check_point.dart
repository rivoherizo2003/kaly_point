import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/enums/person_state_check_point_enum.dart';

class PersonCheckPoint {
  int id;
  int personId;
  int sessionId;
  int checkPointId;
  DateTime createdAt;

  PersonCheckPoint({
    required this.id,
    required this.personId,
    required this.sessionId,
    required this.checkPointId,
    required this.createdAt,
  });

  IconData getIcon(PersonCheckPointDto personCheckPointDto) =>
    PersonStateCheckPointEnum.fromDto(personCheckPointDto).icon;

  Color getColor(PersonCheckPointDto personCheckPointDto) => 
    PersonStateCheckPointEnum.fromDto(personCheckPointDto).color;
}
