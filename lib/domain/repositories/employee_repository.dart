import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/datasources/employeeLocalDataSource.dart';

abstract class EmployeeRepository {
  EmployeeRepository(EmployeeLocalDataSource employeeService);

  Future<List<Employee>> fetchEmployees();
  Future<int> addNewEmployee(EmployeesCompanion employee);
  Future<bool> updateEmployee(EmployeesCompanion employee);
  Future<int> deleteEmployee(int id);
}