import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  static const int _dbVersion = 2;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // final currentDir = Directory.current;
    // final dataDir = Directory(join(currentDir.path, 'data'));

    // if (!dataDir.existsSync()) {
    //   dataDir.createSync(recursive: true);
    // }
    // final path = join(dataDir.path, 'kaly_point.db');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kaly_point.db');

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      );
      ''');

    await _createV2Tables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createV2Tables(db);
    }
  }

  Future<void> _createV2Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS check_points(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        CONSTRAINT fk_sessions
          FOREIGN KEY (session_id)
          REFERENCES sessions (id)
          ON DELETE CASCADE
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS person(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lastname TEXT NOT NULL,
        firstname TEXT,
        created_at TEXT NOT NULL
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS check_point_person(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        check_point_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        CONSTRAINT fk_checkpoint
          FOREIGN KEY (check_point_id)
          REFERENCES check_points (id)
          ON DELETE CASCADE,
        CONSTRAINT fk_person
          FOREIGN KEY (person_id)
          REFERENCES person (id)
          ON DELETE CASCADE
      );

    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS session_person(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_id INTEGER NOT NULL,
        session_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        CONSTRAINT fk_person
          FOREIGN KEY (person_id)
          REFERENCES person (id)
          ON DELETE CASCADE,
        CONSTRAINT fk_session
          FOREIGN KEY (session_id)
          REFERENCES sessions (id)
          ON DELETE CASCADE
      );

    ''');

    await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_session_person 
      ON session_person (person_id, session_id);
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_check_point_person 
      ON check_point_person (person_id, check_point_id);
    ''');
  }
}
