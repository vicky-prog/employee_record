
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:employee_record/data/local/database/table/employee_table.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';


part 'app_database.g.dart'; 



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
