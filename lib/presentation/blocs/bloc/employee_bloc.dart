import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/domain/repositories/employee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository _employeeRepository;

  EmployeeBloc(this._employeeRepository) : super(const EmployeeState()) {
    // Load Employees
    on<LoadEmployees>(_onLoadEmployees);

    // Add Employee
    on<AddEmployee>(_onAddEmployee);

    //  Update Employee
    on<UpdateEmployee>(_onUpdateEmployee);

    //  Delete Employee
    on<DeleteEmployee>(_onDeleteEmployee);

    //  Switch Form State (Add/Edit/List)
    on<SwitchFormState>(_onSwitchFormState);
  }

  /// Handles loading employees
  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final employees = await _employeeRepository.fetchEmployees();
      emit(state.copyWith(employees: employees, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  /// Handles adding a new employee
  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _employeeRepository.addNewEmployee(event.employee);
      add(LoadEmployees()); // Reload list after adding
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Handles updating an employee
  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _employeeRepository.updateEmployee(event.employee);
      add(LoadEmployees()); // Reload list after updating
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Handles deleting an employee
  void _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      await _employeeRepository.deleteEmployee(event.id);
      emit(state.copyWith(successMessage: "Employee has been deleted"));
      add(LoadEmployees()); 
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Handles switching form states (Add/Edit/List)
  void _onSwitchFormState(SwitchFormState event, Emitter<EmployeeState> emit) {
    emit(
      state.copyWith(
        formState: event.formState,
        editingEmployee: event.employee,
        name: event.name,
        selectedRole: event.selectedRole,
        dateOfJoining: event.dateOfJoining,
      ),
    );
  }
}
