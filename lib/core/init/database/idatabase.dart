abstract class IDatabase {
  Future<void> initDB();
  Future<List<Map<String, dynamic>>> getData(
    String path, {
    String? orderField,
    bool descending = false,
  });
  Stream<List<Map<String, dynamic>>> streamData(
    String path, {
    String? orderField,
    bool descending = false,
  });
  Future<Map<String, dynamic>?> getDataById(String path, String id);
  Future<void> addData(String path, String? id, Map<String, dynamic> data);
  Future<void> updateData(String path, Map<String, dynamic> data);
}
