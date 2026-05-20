import 'package:kaly_point/dto/person_check_point_dto.dart';

typedef OnDeletePersonCallback = Future<void> Function(PersonCheckPointDto);
typedef OnEditPersonCallback = Future<void> Function(PersonCheckPointDto);
