import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../istorage_service.dart';

class FirebaseStorageService implements IStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<void> initStorage() async {}

  @override
  Future<String> uploadFile(String path, File file) async {
    final ref = _firebaseStorage.ref(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<String?> getUrlFromPath(String path) async {
    final ref = _firebaseStorage.ref(path);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Future<void> deleteFile(String path) async {
    final ref = _firebaseStorage.ref(path);
    await ref.delete();
  }
}
