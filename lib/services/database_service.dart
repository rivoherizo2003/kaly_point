import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService(){
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async{
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final currentDir = Directory.current;
    final dataDir = Directory(join(currentDir.path, 'data'));
    
    if(!dataDir.existsSync()){
      dataDir.createSync(recursive: true);
    }
    final path = join(dataDir.path, 'kaly_point.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    return db.insert("sessions", session);
  }
}