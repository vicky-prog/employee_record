import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/local/database/employee_dao.dart';


class EmployeeService {
  final EmployeeDao _employeeDao;

  EmployeeService(this._employeeDao);

  Future<List<Employee>> getAllEmployees() async {
    return await _employeeDao.getEmployees();
  }

  Future<int> addEmployee(EmployeesCompanion employee) async {
    return await _employeeDao.insertEmployee(employee);
  }

  Future<bool> updateEmployee(EmployeesCompanion employee) async {
    return await _employeeDao.updateEmployee(employee);
  }

  Future<int> removeEmployee(int id) async {
    return await _employeeDao.deleteEmployee(id);
  }
}
