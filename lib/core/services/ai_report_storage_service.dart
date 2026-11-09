import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/workout/domain/models/workout_ai_models.dart';

/// Secure local storage service persisting the latest AI Coach reports (Program Audit & History Progression).
class AiReportStorageService {
  static const String _kLatestProgramAnalysis = 'strong_latest_program_ai_analysis';
  static const String _kLatestHistoryAnalysis = 'strong_latest_history_ai_analysis';

  final FlutterSecureStorage _storage;

  AiReportStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  /// Saves the latest AI Program Audit analysis.
  Future<void> saveProgramAnalysis(ProgramAiAnalysis analysis) async {
    final encoded = jsonEncode(analysis.toJson());
    await _storage.write(key: _kLatestProgramAnalysis, value: encoded);
  }

  /// Retrieves the latest AI Program Audit analysis, or null if none saved.
  Future<ProgramAiAnalysis?> getLatestProgramAnalysis() async {
    try {
      final raw = await _storage.read(key: _kLatestProgramAnalysis);
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ProgramAiAnalysis.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Saves the latest AI History Progression analysis.
  Future<void> saveHistoryAnalysis(HistoryAiAnalysis analysis) async {
    final encoded = jsonEncode(analysis.toJson());
    await _storage.write(key: _kLatestHistoryAnalysis, value: encoded);
  }

  /// Retrieves the latest AI History Progression analysis, or null if none saved.
  Future<HistoryAiAnalysis?> getLatestHistoryAnalysis() async {
    try {
      final raw = await _storage.read(key: _kLatestHistoryAnalysis);
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return HistoryAiAnalysis.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Clears stored AI reports.
  Future<void> clearAllReports() async {
    await _storage.delete(key: _kLatestProgramAnalysis);
    await _storage.delete(key: _kLatestHistoryAnalysis);
  }
}
