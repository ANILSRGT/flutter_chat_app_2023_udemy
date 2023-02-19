import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../firebase_options.dart';
import '../idatabase.dart';

class FirestoreDB implements IDatabase {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  @override
  Future<void> initDB() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getData(
    String path, {
    String? orderField,
    bool descending = false,
  }) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (orderField != null) {
      snapshot = await _firestore.collection(path).orderBy(orderField, descending: true).get();
    } else {
      snapshot = await _firestore.collection(path).get();
    }
    final data = snapshot.docs.map((e) => e.data()).toList();
    return data;
  }

  @override
  Stream<List<Map<String, dynamic>>> streamData(
    String path, {
    String? orderField,
    bool descending = false,
  }) {
    Stream<List<Map<String, dynamic>>> res;
    if (orderField != null) {
      res = _firestore
          .collection(path)
          .orderBy(orderField, descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());
    } else {
      res = _firestore
          .collection(path)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>?> getDataById(String path, String id) {
    final res = _firestore.collection(path).doc(id).get();
    return res.then((value) => value.data());
  }

  @override
  Future<void> addData(String path, String? id, Map<String, dynamic> data) async {
    if (id != null) {
      await _firestore.collection(path).doc(id).set(data);
    } else {
      await _firestore.collection(path).add(data);
    }
  }

  @override
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _firestore.doc(path).update(data);
  }
}
