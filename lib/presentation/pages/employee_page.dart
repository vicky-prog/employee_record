import 'package:drift/drift.dart' show Value;
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:employee_record/presentation/widgets/calendar_dialog.dart';
import 'package:employee_record/presentation/widgets/date_selection_row.dart';
import 'package:employee_record/presentation/widgets/fotter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_record/data/local/database/app_database.dart';

double _radies = 4;
double _inputFiledheight = 45;
const sizedBoxSpacing = SizedBox(height: 20);

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String selectedRole = "Select role";

  final TextEditingController nameController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  void _showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            _buildRoleOption("Product Designer"),
            _buildRoleOption("Flutter Developer"),
            _buildRoleOption("QA Tester"),
            _buildRoleOption("Product Owner"),
          ],
        );
      },
    );
  }

  Widget _buildRoleOption(String role) {
    return ListTile(
      title: Text(role, textAlign: TextAlign.center),
      onTap: () {
        setState(() {
          selectedRole = role;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<EmployeeBloc>().state;

    if (state.formState == EmployeeFormState.edit && state.editingEmployee != null) {
      nameController.text = state.editingEmployee!.name;
      selectedRole = state.editingEmployee!.position ?? "Select role";
      _fromDate = state.editingEmployee!.dateOfJoining;
      _toDate = state.editingEmployee!.lastWorkingDay;
    } else if (state.formState == EmployeeFormState.add) {
      nameController.clear();
      selectedRole = "Select role";
      _fromDate = null;
      _toDate = null;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeBloc>().add(LoadEmployees());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_buildAppBarTitle(context))),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          } else if (state.formState == EmployeeFormState.list) {
            return _buildEmployeeList(context, state);
          } else {
            return _buildEmployeeForm(context, state);
          }
        },
      ),

      floatingActionButton:
          context.watch<EmployeeBloc>().state.formState ==
                  EmployeeFormState.list
              ? FloatingActionButton(
                onPressed: () {
                  context.read<EmployeeBloc>().add(
                    SwitchFormState(formState: EmployeeFormState.add),
                  );
                },
                child: Icon(Icons.add),
              )
              : null,
    );
  }

  String _buildAppBarTitle(BuildContext context) {
    final state = context.watch<EmployeeBloc>().state;

    switch (state.formState) {
      case EmployeeFormState.list:
        return "Employee List";
      case EmployeeFormState.add:
        return "Add Employee Details";
      case EmployeeFormState.edit:
        return "Edit Employee Details";
    }
  }

  //  Employee List View
  Widget _buildEmployeeList(BuildContext context, EmployeeState state) {
    if (state.employees.isEmpty) {
      return Center(
        child: Image.asset(
          'assets/images/no_record.png', // Replace with your actual image path
          height: 150,
        ),
      );
    }
    return ListView.builder(
      itemCount: state.employees.length,
      itemBuilder: (context, index) {
        final employee = state.employees[index];
        return ListTile(
          title: Text(employee.name),
          subtitle: Text(employee.position ?? "No role"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  context.read<EmployeeBloc>().add(
                    SwitchFormState(
                      formState: EmployeeFormState.edit,
                      employee: employee,
                      name: employee.name,
                      selectedRole: employee.position ?? "Select role",
                      dateOfJoining: employee.dateOfJoining,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<EmployeeBloc>().add(DeleteEmployee(employee.id));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Employee Form (Add/Edit)
  Widget _buildEmployeeForm(BuildContext context, EmployeeState state) {
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Employee Name Field
                  _employeeNameField(),
                  sizedBoxSpacing,
                  // Select Role Field (Clickable)
                  _selectRoleField(),
                  sizedBoxSpacing,

                  // Date Selection Row
                  DateSelectionRow(
                    onFromDateTap: () {
                      _openCalendarDialog(false);
                    },
                    onToDateTap: () {
                      _openCalendarDialog(true);
                    },
                    fromDate: _fromDate,
                    toDate: _toDate,
                  ),
                ],
              ),
            ),
          ),
        ),

        EmployeeFormActions(
          onCancel: () {
            context.read<EmployeeBloc>().add(
              SwitchFormState(formState: EmployeeFormState.list),
            );
          },
          onSave: () {
            _saveEmployee(context, state);
          },
        ),
      ],
    );
  }

  _employeeNameField() {
    return SizedBox(
      height: _inputFiledheight,
      child: TextFormField(
        controller: nameController,
        cursorHeight: 18,
        decoration: InputDecoration(
          hintText: "Employee name",
          prefixIcon: const Icon(Icons.person, color: Colors.blue, size: 18),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  _selectRoleField() {
    return GestureDetector(
      onTap: _showRoleBottomSheet,
      child: Container(
        width: double.infinity,
        height: _inputFiledheight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(_radies),
        ),
        child: Row(
          children: [
            const Icon(Icons.work, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedRole,
                style: TextStyle(
                  color:
                      selectedRole == "Select role"
                          ? Colors.grey
                          : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  _saveEmployee(BuildContext context, EmployeeState state) {
    final employee = EmployeesCompanion(
      id:
          state.editingEmployee != null
              ? Value(state.editingEmployee!.id)
              : const Value.absent(),
      name: Value(nameController.text),
      position: Value(selectedRole),
      dateOfJoining: Value(_fromDate ?? DateTime.now()),
      lastWorkingDay: _toDate != null ? Value(_toDate!) : const Value.absent(),
    );

    if (state.formState == EmployeeFormState.add) {
      context.read<EmployeeBloc>().add(AddEmployee(employee));
    } else {
      context.read<EmployeeBloc>().add(UpdateEmployee(employee));
    }

    context.read<EmployeeBloc>().add(
      SwitchFormState(formState: EmployeeFormState.list),
    );
  }

  void _openCalendarDialog(bool toDate) {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(
          toDate: toDate,
          selectedDay:
              toDate ? _toDate ?? DateTime.now() : _fromDate ?? DateTime.now(),
          onDateSelected: (newDate) {
            // if (newDate != null) {
            setState(() {
              if (toDate) {
                _toDate = newDate;
              } else {
                _fromDate = newDate;
              }
            });
            //}
          },
        );
      },
    );
  }
}
