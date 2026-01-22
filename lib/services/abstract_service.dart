import 'package:kaly_point/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractService {
  late Database db;
  late DatabaseService databaseService;
  
  Future<void> initDB() async {
    db = await databaseService.database;
  }
}
