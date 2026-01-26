
import 'package:kaly_point/dto/person_check_point_dto.dart';

class PersonCheckPoint {
  int id;
  int personId;
  int sessionId;
  int checkPointId;
  DateTime createdAt;

  PersonCheckPoint({required this.id, required this.personId, required this.sessionId, required this.checkPointId, required this.createdAt});
}