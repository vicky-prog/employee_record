part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}

// ✅ New state for when an employee is updated
class EmployeeUpdated extends EmployeeState {
  final Employee employee;
  EmployeeUpdated(this.employee);

  @override
  List<Object?> get props => [employee];
}
