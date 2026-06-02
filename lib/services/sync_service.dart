import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Database _localDb;

  SyncService(this._localDb);

  // Liste de nos tables pour itérer plus facilement
  final List<String> _tables = [
    'person',
    'sessions',
    'check_points',
    'session_person',
    'check_point_person'
  ];

  /// =========================================
  /// ACTION 1 : SYNC (De SQLite vers Firebase)
  /// =========================================
  Future<void> syncToFirebase() async {
    try {
      // 1. Initialisation du premier batch (notre première camionnette)
      WriteBatch batch = _firestore.batch();
      
      // Compteurs pour suivre l'avancement
      int operationCount = 0; 
      int totalOperations = 0; 

      for (String table in _tables) {
        final List<Map<String, dynamic>> rows = await _localDb.query(table);

        for (var row in rows) {
          final docRef = _firestore.collection(table).doc(row['id'].toString());
          batch.set(docRef, row);
          
          operationCount++;
          totalOperations++;

          // 2. VÉRIFICATION DE LA LIMITE
          // Dès qu'on atteint 500 opérations, on doit envoyer (commit)
          if (operationCount == 500) {
            await batch.commit();
            print("🚚 Un lot de 500 documents a été expédié à Firebase...");
            
            // 3. RÉINITIALISATION
            // On prépare un tout nouveau batch pour les données suivantes
            batch = _firestore.batch();
            operationCount = 0;
          }
        }
      }

      // 4. LE RESTE (Les "leftovers")
      // Après la fin des boucles, il y a de fortes chances que le dernier batch 
      // ne soit pas parfaitement tombé sur un multiple de 500. 
      // On vérifie s'il reste des opérations en attente.
      if (operationCount > 0) {
        await batch.commit();
        print("🚚 Le dernier lot de $operationCount documents a été expédié...");
      }

      print("✅ Synchronisation réussie ! Total envoyé : $totalOperations documents.");

    } catch (e) {
      print("❌ Erreur lors de la synchronisation en lots : $e");
    }
  }

  /// =========================================
  /// ACTION 2 : LOAD (De Firebase vers SQLite)
  /// =========================================
  Future<void> loadFromFirebase() async {
    try {
      // 1. On récupère d'abord toutes les données depuis Firebase pour chaque collection
      Map<String, List<Map<String, dynamic>>> firebaseData = {};
      
      for (String table in _tables) {
        final snapshot = await _firestore.collection(table).get();
        // On stocke les données brutes dans notre map
        firebaseData[table] = snapshot.docs.map((doc) => doc.data()).toList();
      }

      // 2. On utilise une Transaction SQLite. 
      // Si une insertion échoue, la base de données annule TOUT et revient à l'état initial.
      await _localDb.transaction((txn) async {
        
        // 3. EFFACEMENT : Il faut respecter les contraintes de clés étrangères (Foreign Keys) !
        // On supprime d'abord les tables enfants, puis les tables parents.
        await txn.delete('check_point_person');
        await txn.delete('session_person');
        await txn.delete('check_points');
        await txn.delete('sessions');
        await txn.delete('person');

        // 4. INSERTION : L'ordre inverse ! 
        // On insère d'abord les parents (person, sessions) avant les enfants.
        final List<String> insertOrder = [
          'person',
          'sessions',
          'check_points',
          'session_person',
          'check_point_person'
        ];

        for (String table in insertOrder) {
          final rows = firebaseData[table] ?? [];
          for (var row in rows) {
             // INSERT OR REPLACE est plus sûr en cas de conflit d'ID
            await txn.insert(
              table, 
              row, 
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      });

      print("✅ Chargement depuis Firebase réussi !");

    } catch (e) {
      print("❌ Erreur lors du chargement : $e");
    }
  }
}