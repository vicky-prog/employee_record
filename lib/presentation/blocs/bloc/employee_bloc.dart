import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/repositories/employee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository _employeeRepository;

  EmployeeBloc(this._employeeRepository) : super(const EmployeeState()) {
    // ✅ Load Employees
    on<LoadEmployees>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final employees = await _employeeRepository.fetchEmployees();
        emit(state.copyWith(employees: employees, isLoading: false));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      }
    });

    // ✅ Add Employee
    on<AddEmployee>((event, emit) async {
      await _employeeRepository.addNewEmployee(event.employee);
      add(LoadEmployees()); // Reload list after adding
    });

    // ✅ Update Employee
    on<UpdateEmployee>((event, emit) async {
      await _employeeRepository.updateEmployee(event.employee);
      add(LoadEmployees()); // Reload list after updating
    });

    // ✅ Delete Employee
    on<DeleteEmployee>((event, emit) async {
      await _employeeRepository.deleteEmployee(event.id);
      add(LoadEmployees()); // Reload list after deleting
    });

    // ✅ Switch Form State (Add/Edit/List)
    on<SwitchFormState>((event, emit) {
      emit(state.copyWith(
        formState: event.formState,
        editingEmployee: event.employee,
        name: event.name,
        selectedRole: event.selectedRole,
        dateOfJoining: event.dateOfJoining
      ));
    });
  }
}
