import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:employee_record/data/local/employee_dao.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart'; // ✅ Ensure this is present!

@DataClassName('Employee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get position => text().nullable()();
  DateTimeColumn get dateOfJoining => dateTime()();
}

@DriftDatabase(tables: [Employees], daos: [EmployeeDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
