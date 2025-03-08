part of 'employee_bloc.dart';

enum EmployeeFormState { list, add, edit }

class EmployeeState extends Equatable {
  final List<Employee> employees;
  final EmployeeFormState formState;
  final Employee? editingEmployee;
  final String selectedRole;
  final String name;
  final String? errorMessage;
  final String? successMessage;
  final bool isLoading;
  final DateTime? dateOfJoining; 

  const EmployeeState({
    this.employees = const [],
    this.formState = EmployeeFormState.list,
    this.editingEmployee,
    this.selectedRole = "Select role",
    this.name = "",
    this.errorMessage,
    this.successMessage,
    this.isLoading = false,
    this.dateOfJoining, 
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    EmployeeFormState? formState,
    Employee? editingEmployee,
    String? selectedRole,
    String? name,
    String? errorMessage,
    String? successMessage,
    bool? isLoading,
    DateTime? dateOfJoining, 
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      formState: formState ?? this.formState,
      editingEmployee: editingEmployee,
      selectedRole: selectedRole ?? this.selectedRole,
      name: name ?? this.name,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isLoading: isLoading ?? this.isLoading,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining, 
    );
  }

  @override
  List<Object?> get props => [
        employees,
        formState,
        editingEmployee,
        selectedRole,
        name,
        errorMessage,
        successMessage,
        isLoading,
        dateOfJoining, 
      ];
}
