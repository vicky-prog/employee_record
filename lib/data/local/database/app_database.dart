
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:path_provider/path_provider.dart';
import 'connection/connection.dart' as impl;

part 'app_database.g.dart'; // Ensure this is generated!

@DataClassName('Employee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get position => text().nullable()();
  DateTimeColumn get dateOfJoining => dateTime()();
}

@DriftDatabase(tables: [Employees])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'employee_db',
                native: const DriftNativeOptions(
                  databaseDirectory: getApplicationDocumentsDirectory,
                ),
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                  onResult: (result) {
                    if (result.missingFeatures.isNotEmpty) {
                      debugPrint(
                        'Using ${result.chosenImplementation} due to unsupported '
                        'browser features: ${result.missingFeatures}',
                      );
                    }
                  },
                ),
              ),
        );
AppDatabase.forTesting(DatabaseConnection super.connection);
  @override
  int get schemaVersion => 1;


 
}
