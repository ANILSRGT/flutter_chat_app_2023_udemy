import 'dart:io';

abstract class IStorageService {
  Future<void> initStorage();
  Future<String> uploadFile(String path, File file);
  Future<String?> getUrlFromPath(String path);
  Future<void> deleteFile(String path);
}
