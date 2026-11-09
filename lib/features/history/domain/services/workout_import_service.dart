import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/database/app_database.dart';

/// Service responsible for validating, parsing, and restoring full JSON backups
/// produced by [WorkoutExportService].
class WorkoutImportService {
  final AppDatabase db;
  final Future<Directory> Function()? tempDirectoryProvider;

  WorkoutImportService(this.db, {this.tempDirectoryProvider});

  Future<Directory> _getTempDir() async {
    if (tempDirectoryProvider != null) {
      return tempDirectoryProvider!();
    }
    return getTemporaryDirectory();
  }

  /// Parses and imports a JSON backup from raw JSON text.
  Future<BackupImportResult> importFromJsonString(
    String jsonContent, {
    bool overwrite = false,
  }) async {
    final trimmed = jsonContent.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Backup content is empty.');
    }

    final dynamic decoded = jsonDecode(trimmed);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup root must be a JSON object.');
    }

    return db.importBackupTransaction(decoded, overwrite: overwrite);
  }

  /// Reads a `.json` backup [file], imports its records inside an atomic SQLite
  /// transaction, and optionally purges the temporary file afterwards.
  Future<BackupImportResult> importFromFile(
    File file, {
    bool overwrite = false,
    bool purgeTempFileAfterRead = true,
  }) async {
    if (!await file.exists()) {
      throw FileSystemException('Backup file does not exist', file.path);
    }

    try {
      final rawContent = await file.readAsString();
      return await importFromJsonString(rawContent, overwrite: overwrite);
    } finally {
      if (purgeTempFileAfterRead) {
        try {
          final tempDir = await _getTempDir();
          if (file.path.startsWith(tempDir.path) && await file.exists()) {
            await file.delete();
          }
        } catch (_) {
          // Ignore cleanup errors on OS temp directory
        }
      }
    }
  }

  /// Discovers any available `.json` backup files in the application's temporary
  /// or documents directories for quick 1-tap local restoration.
  Future<List<File>> listAvailableLocalBackups() async {
    final List<File> backups = [];
    try {
      final tempDir = await _getTempDir();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list()) {
          if (entity is File && entity.path.toLowerCase().endsWith('.json')) {
            backups.add(entity);
          }
        }
      }
    } catch (_) {}

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (await docsDir.exists()) {
        await for (final entity in docsDir.list()) {
          if (entity is File && entity.path.toLowerCase().endsWith('.json')) {
            backups.add(entity);
          }
        }
      }
    } catch (_) {}

    backups.sort(
      (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );
    return backups;
  }
}
