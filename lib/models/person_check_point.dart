import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/enums/person_state_check_point_enum.dart';
import 'package:kaly_point/models/check_point.dart';

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

  static IconData getIcon(PersonCheckPointDto personCheckPointDto, CheckPoint currentCheckPoint) =>
    PersonStateCheckPointEnum.fromDto(personCheckPointDto, currentCheckPoint).icon;

  static Color getColor(PersonCheckPointDto personCheckPointDto, CheckPoint currentCheckPoint) => 
    PersonStateCheckPointEnum.fromDto(personCheckPointDto, currentCheckPoint).color;
}
