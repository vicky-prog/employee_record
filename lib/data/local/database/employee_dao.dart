import 'package:drift/drift.dart';
import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/local/database/table/employee_table.dart';

part 'employee_dao.g.dart'; // ✅ Ensure this is present!

@DriftAccessor(tables: [Employees])
class EmployeeDao extends DatabaseAccessor<AppDatabase> with _$EmployeeDaoMixin {
  final AppDatabase db;

  EmployeeDao(this.db) : super(db);

  Future<List<Employee>> getEmployees() => select(employees).get();
  Future<int> insertEmployee(EmployeesCompanion employee) => into(employees).insert(employee);
    Future<bool> updateEmployee(EmployeesCompanion employee) => 
      update(employees).replace(employee);
  Future<int> deleteEmployee(int id) => (delete(employees)..where((e) => e.id.equals(id))).go();
}
