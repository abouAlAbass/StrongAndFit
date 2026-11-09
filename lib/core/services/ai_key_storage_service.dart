import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service responsible for securely persisting and retrieving the user's
/// Google Gemini API key on Android (Keystore) and iOS (Keychain).
class AiKeyStorageService {
  static const String _kGeminiApiKey = 'gemini_user_api_key';

  final FlutterSecureStorage _storage;

  AiKeyStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  /// Saves the Gemini API key securely in encrypted hardware-backed storage.
  Future<void> saveApiKey(String key) async {
    final sanitized = key.trim();
    if (sanitized.isEmpty) {
      await deleteApiKey();
      return;
    }
    await _storage.write(key: _kGeminiApiKey, value: sanitized);
  }

  /// Retrieves the persisted API key, or null if none is saved.
  Future<String?> getApiKey() async {
    try {
      final key = await _storage.read(key: _kGeminiApiKey);
      return (key != null && key.trim().isNotEmpty) ? key.trim() : null;
    } catch (_) {
      return null;
    }
  }

  /// Removes the stored API key.
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _kGeminiApiKey);
  }

  /// Checks if a valid non-empty API key is configured.
  Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }
}
