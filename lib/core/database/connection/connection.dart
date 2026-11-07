import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Opens the SQLite database connection using modern drift_flutter APIs.
///
/// Ensures 100% offline persistence with isolate sharing and automatic file management
/// in standard OS document directories.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    return driftDatabase(
      name: 'strong_app_database',
      native: const DriftNativeOptions(
        shareAcrossIsolates: true,
      ),
    );
  });
}
