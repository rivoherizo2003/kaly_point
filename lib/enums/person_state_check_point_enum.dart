import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/models/person.dart';

enum PersonStateCheckPointEnum {
  notInSession(Icons.person_add_alt_1, Colors.blue),
  inSessionNotServed(Icons.assignment_add, Color(0xFFFFAB91)),
  inSessionAndServed(Icons.done_all, Colors.green),
  noState(Icons.question_mark, Colors.grey);

  final IconData icon;
  final Color color;
  const PersonStateCheckPointEnum(this.icon, this.color);

  static PersonStateCheckPointEnum fromDto(
    PersonCheckPointDto personCheckPointDto,
    CheckPoint currentCheckPoint
  ) {
    if (Person.isNotInSession(personCheckPointDto, currentCheckPoint)) {
      return PersonStateCheckPointEnum.notInSession;
    }

    if (Person.inSessionNotServed(personCheckPointDto, currentCheckPoint)) {
      return PersonStateCheckPointEnum.inSessionNotServed;
    }

    if (Person.inSessionAndServed(personCheckPointDto, currentCheckPoint)) {
      return PersonStateCheckPointEnum.inSessionAndServed;
    }

    return PersonStateCheckPointEnum.noState;
  }
}
