import 'package:employee_record/data/local/app_database.dart';
import 'package:employee_record/data/local/services/employee_service.dart';

class EmployeeRepository {
  final EmployeeService _employeeService;

  EmployeeRepository(this._employeeService);

  Future<List<Employee>> fetchEmployees() => _employeeService.getAllEmployees();
  Future<int> addNewEmployee(EmployeesCompanion employee) => _employeeService.addEmployee(employee);
   Future<bool> updateEmployee(Employee employee) => 
      _employeeService.updateEmployee(employee);
  Future<int> deleteEmployee(int id) => _employeeService.removeEmployee(id);
}
