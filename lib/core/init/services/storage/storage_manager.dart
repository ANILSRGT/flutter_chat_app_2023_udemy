import 'dart:io';

import 'services/firebase_storage_service.dart';

import 'istorage_service.dart';

class StorageManager implements IStorageService {
  static final StorageManager _instance = StorageManager._init();
  static StorageManager get instance => _instance;

  StorageManager._init();

  IStorageService _storage = FirebaseStorageService();

  void changeStorage(IStorageService storage) {
    _storage = storage;
  }

  @override
  Future<void> initStorage() async {
    await _storage.initStorage();
  }

  @override
  Future<String> uploadFile(String path, File file) {
    return _storage.uploadFile(path, file);
  }

  @override
  Future<String?> getUrlFromPath(String path) {
    return _storage.getUrlFromPath(path);
  }

  @override
  Future<void> deleteFile(String path) async {
    await _storage.deleteFile(path);
  }
}
