part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object?> get props => [];
}

// ✅ Load Employees
class LoadEmployees extends EmployeeEvent {}

// ✅ Add a New Employee
class AddEmployee extends EmployeeEvent {
  final EmployeesCompanion employee;
  const AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

// ✅ Update an Employee
class UpdateEmployee extends EmployeeEvent {
  final EmployeesCompanion employee;
  const UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

// ✅ Delete an Employee
class DeleteEmployee extends EmployeeEvent {
  final int id;
  const DeleteEmployee(this.id);

  @override
  List<Object?> get props => [id];
}

class SwitchFormState extends EmployeeEvent {
  final EmployeeFormState formState;
  final Employee? employee;
  final String name;
  final String selectedRole;
  final DateTime? dateOfJoining; // ✅ Added Date of Joining

  const SwitchFormState({
    required this.formState,
    this.employee,
    this.name = "",
    this.selectedRole = "Select role",
    this.dateOfJoining, // ✅ Default to null
  });

  @override
  List<Object?> get props => [formState, employee, name, selectedRole, dateOfJoining];
}

