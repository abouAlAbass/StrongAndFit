import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/database/app_database.dart';

/// Service responsible for offline-first data backup and exports.
///
/// Supports:
/// - CSV export compatible with Excel, Google Sheets, Strong App, and Hevy.
/// - Full JSON structured backup containing profiles, sessions, exercises, and sets.
class WorkoutExportService {
  final AppDatabase db;
  final Future<Directory> Function()? tempDirectoryProvider;

  WorkoutExportService(this.db, {this.tempDirectoryProvider});

  Future<Directory> _getTempDir() async {
    if (tempDirectoryProvider != null) {
      return tempDirectoryProvider!();
    }
    return getTemporaryDirectory();
  }

  /// Generates a standardized CSV string and saves it to a temporary file.
  Future<File> generateCsvExport() async {
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.completedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
        .get();

    final buffer = StringBuffer();
    // International standard CSV header
    buffer.writeln(
      'Date,Workout Name,Duration (min),Exercise,Muscle Group,Set Number,Set Type,Weight (kg),Reps,RPE,Completed',
    );

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    for (final session in sessions) {
      final dateStr = dateFormat.format(session.startedAt);
      final durationMin = (session.durationSeconds / 60.0).round();
      final escapedTitle = _escapeCsv(session.title);

      final exercises = await (db.select(db.workoutExercises)
            ..where((t) => t.sessionId.equals(session.id))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

      for (final we in exercises) {
        final exerciseRecord = await (db.select(db.exercises)
              ..where((t) => t.id.equals(we.exerciseId)))
            .getSingleOrNull();

        final exerciseName = exerciseRecord != null
            ? (exerciseRecord.isCustom && exerciseRecord.customName != null
                ? exerciseRecord.customName!
                : exerciseRecord.slug)
            : 'Unknown';
        final muscle = exerciseRecord?.muscleGroup.name ?? '';

        final sets = await (db.select(db.setLogs)
              ..where((t) => t.workoutExerciseId.equals(we.id))
              ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .get();

        for (final s in sets) {
          buffer.writeln(
            '"$dateStr",'
            '"$escapedTitle",'
            '$durationMin,'
            '"${_escapeCsv(exerciseName)}",'
            '"$muscle",'
            '${s.setNumber},'
            '"${s.setType.name}",'
            '${s.weightKg ?? 0},'
            '${s.reps ?? 0},'
            '${s.rpe != null ? s.rpe!.toStringAsFixed(1) : ""},'
            '${s.isCompleted ? 1 : 0}',
          );
        }
      }
    }

    final tempDir = await _getTempDir();
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${tempDir.path}/strong_workouts_$timestamp.csv');
    await file.writeAsString(buffer.toString());
    return file;
  }

  /// Generates a comprehensive JSON backup with all relational records.
  Future<File> generateJsonBackup() async {
    final profile = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
    final sessions = await db.select(db.workoutSessions).get();
    final workoutExercises = await db.select(db.workoutExercises).get();
    final sets = await db.select(db.setLogs).get();
    final customExercises = await (db.select(db.exercises)
          ..where((t) => t.isCustom.equals(true)))
        .get();

    final backupData = {
      'app': 'Strong Track',
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': profile != null
          ? {
              'name': profile.name,
              'weightKg': profile.weightKg,
              'heightCm': profile.heightCm,
              'weeklyWorkoutGoal': profile.weeklyWorkoutGoal,
              'experienceLevel': profile.experienceLevel.name,
            }
          : null,
      'customExercises': customExercises
          .map((e) => {
                'id': e.id,
                'slug': e.slug,
                'customName': e.customName,
                'muscleGroup': e.muscleGroup.name,
                'equipment': e.equipment.name,
              })
          .toList(),
      'sessions': sessions
          .map((s) => {
                'id': s.id,
                'title': s.title,
                'startedAt': s.startedAt.toIso8601String(),
                'durationSeconds': s.durationSeconds,
                'completedAt': s.completedAt?.toIso8601String(),
                'notes': s.notes,
              })
          .toList(),
      'workoutExercises': workoutExercises
          .map((we) => {
                'id': we.id,
                'sessionId': we.sessionId,
                'exerciseId': we.exerciseId,
                'orderIndex': we.orderIndex,
              })
          .toList(),
      'sets': sets
          .map((st) => {
                'id': st.id,
                'workoutExerciseId': st.workoutExerciseId,
                'setNumber': st.setNumber,
                'setType': st.setType.name,
                'weightKg': st.weightKg,
                'reps': st.reps,
                'rpe': st.rpe,
                'isCompleted': st.isCompleted,
              })
          .toList(),
    };

    final tempDir = await _getTempDir();
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${tempDir.path}/strong_backup_$timestamp.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(backupData));
    return file;
  }

  /// Exports workouts to CSV and triggers native OS share sheet.
  Future<void> shareCsv() async {
    final file = await generateCsvExport();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Export Strong Track (CSV)',
        subject: 'Strong Track Workout History',
      ),
    );
  }

  /// Exports full database backup to JSON and triggers native OS share sheet.
  Future<void> shareJson() async {
    final file = await generateJsonBackup();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Sauvegarde Strong Track (JSON)',
        subject: 'Strong Track Backup',
      ),
    );
  }

  String _escapeCsv(String input) {
    return input.replaceAll('"', '""');
  }
}
