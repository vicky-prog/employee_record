import 'package:employee_record/data/datasources/employeeLocalDataSource.dart';
import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/domain/repositories/employee_repository.dart';


class EmployeeService implements EmployeeRepository {
  final EmployeeLocalDataSource _employeeService;

  EmployeeService(this._employeeService);

  @override
  Future<List<Employee>> fetchEmployees() => _employeeService.getAllEmployees();

  @override
  Future<int> addNewEmployee(EmployeesCompanion employee) => 
      _employeeService.addEmployee(employee);

  @override
  Future<bool> updateEmployee(EmployeesCompanion employee) => 
      _employeeService.updateEmployee(employee);

  @override
  Future<int> deleteEmployee(int id) => _employeeService.removeEmployee(id);
}


