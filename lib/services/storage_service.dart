import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/storage_item.dart';

class StorageService {
  static AndroidOptions androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static IOSOptions iosOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final _secureStorage =
      FlutterSecureStorage(aOptions: androidOptions, iOptions: iosOptions);

  Future<void> writeSecureData(StorageItem newItem) async {
    await _secureStorage.write(
      key: newItem.key,
      value: newItem.value,
    );
  }

  Future<String?> readSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(StorageItem item) async {
    await _secureStorage.delete(
      key: item.key,
    );
  }

  Future<List<StorageItem>> readAllSecureData() async {
    var allData = await _secureStorage.readAll();

    return allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> containsKeyInSecureData(String key) async {
    return await _secureStorage.containsKey(key: key);
  }
}
