import 'dart:math';

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
  }

  Future<void> seedDatabase() async {
    final db = await database;
    final batch = db.batch();
    final random = Random();

    print("🌱 Début du remplissage de la base de données...");

    // 1. Générer 100 SESSIONS
    for (int i = 1; i <= 100; i++) {
      batch.insert('sessions', {
        'title': 'Session de Formation #$i',
        'description': 'Description détaillée de la session numéro $i',
        'created_at': DateTime.now()
            .subtract(Duration(days: i))
            .toIso8601String(),
      });
    }

    // 2. Générer 100 PERSONNES
    final firstNames = [
      'Jean',
      'Marie',
      'Pierre',
      'Sophie',
      'Paul',
      'Julie',
      'Lucas',
      'Emma',
    ];
    final lastNames = [
      'Dupont',
      'Martin',
      'Bernard',
      'Thomas',
      'Petit',
      'Robert',
      'Richard',
      'Durand',
    ];

    for (int i = 1; i <= 100; i++) {
      batch.insert('person', {
        'firstname': firstNames[random.nextInt(firstNames.length)],
        'lastname':
            '${lastNames[random.nextInt(lastNames.length)]} $i', // Ajout de i pour l'unicité
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // 3. Générer 100 CHECK_POINTS (Liés aux sessions)
    // On suppose que les sessions ont des ID de 1 à 100 (générés ci-dessus)
    for (int i = 1; i <= 100; i++) {
      int randomSessionId = random.nextInt(100) + 1; // ID entre 1 et 100
      batch.insert('check_points', {
        'session_id': randomSessionId,
        'title': 'Point de contrôle $i',
        'description': 'Vérification standard pour ce point.',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // 4. Générer 100 LIENS (CheckPoint <-> Person)
    // On lie des personnes aléatoires à des checkpoints aléatoires
    for (int i = 1; i <= 100; i++) {
      int randomPersonId = random.nextInt(100) + 1;
      int randomCheckPointId = random.nextInt(100) + 1;

      batch.insert('check_point_person', {
        'person_id': randomPersonId,
        'check_point_id': randomCheckPointId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // 4. Générer 100 LIENS (CheckPoint <-> Person)
    // On lie des personnes aléatoires à des checkpoints aléatoires
    for (int i = 1; i <= 100; i++) {
      int randomPersonId = random.nextInt(100) + 1;
      int randomSessionId = random.nextInt(100) + 1;

      batch.insert('session_person', {
        'person_id': randomPersonId,
        'session_id': randomSessionId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    await batch.commit(noResult: true);
    print("✅ Base de données remplie avec 400+ lignes de test !");
  }
}
