import 'databases/firestore_database.dart';
import 'idatabase.dart';

class DatabaseManager implements IDatabase {
  static final DatabaseManager _instance = DatabaseManager._init();
  static DatabaseManager get instance => _instance;

  DatabaseManager._init();

  IDatabase _database = FirestoreDB();
  IDatabase get database => _database;

  void changeDatabase(IDatabase database) {
    _database = database;
  }

  @override
  Future<void> initDB() async {
    await _database.initDB();
  }

  @override
  Future<List<Map<String, dynamic>>> getData(
    String path, {
    String? orderField,
    bool descending = false,
  }) async {
    return await _database.getData(path, orderField: orderField, descending: descending);
  }

  @override
  Future<Map<String, dynamic>?> getDataById(String path, String id) async {
    return await _database.getDataById(path, id);
  }

  @override
  Stream<List<Map<String, dynamic>>> streamData(
    String path, {
    String? orderField,
    bool descending = false,
  }) {
    final res = _database.streamData(path, orderField: orderField, descending: descending);
    return res;
  }

  @override
  Future<void> addData(String path, String? id, Map<String, dynamic> data) async {
    await _database.addData(path, id, data);
  }

  @override
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _database.updateData(path, data);
  }
}
