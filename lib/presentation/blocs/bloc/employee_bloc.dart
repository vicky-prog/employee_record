

import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/repositories/employee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_event.dart';
part 'employee_state.dart';



class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository _employeeRepository;

  EmployeeBloc(this._employeeRepository) : super(EmployeeInitial()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await _employeeRepository.fetchEmployees();
        emit(EmployeeLoaded(employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      await _employeeRepository.addNewEmployee(event.employee);
      add(LoadEmployees()); // Refresh list after adding
    });

     on<UpdateEmployee>((event, emit) async {
      await _employeeRepository.updateEmployee(event.employee);
      add(LoadEmployees()); // Refresh the list after update
    });

    on<DeleteEmployee>((event, emit) async {
      await _employeeRepository.deleteEmployee(event.id);
      add(LoadEmployees()); // Refresh list after deleting
    });
  }
}
