import 'package:drift/drift.dart' show Value;
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:employee_record/presentation/widgets/calendar_dialog.dart';
import 'package:employee_record/presentation/widgets/date_selection_row.dart';
import 'package:employee_record/presentation/widgets/employee_list.dart';
import 'package:employee_record/presentation/widgets/fotter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_record/data/local/database/app_database.dart';

double _radies = 4;
double _inputFiledheight = 45;
const sizedBoxSpacing = SizedBox(height: 20);
double webWidth = 900;

 final ButtonStyle webButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 14.0), 
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), 
  ),
  textStyle: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  ),
);

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String selectedRole = "";

  final TextEditingController nameController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _roles = ["Product Designer","Flutter Developer","QA Tester","Product Owner"];

  void _showRoleBottomSheet() {
    showModalBottomSheet(
      
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListView.separated(
               shrinkWrap: true,
              itemBuilder: (context, index,)=>_buildRoleOption(_roles[index]), 
               separatorBuilder: (context, index) =>
              Divider(thickness: 0.5, height: 0.8, color: Colors.grey.shade300),
               itemCount: _roles.length),
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

    if (state.formState == EmployeeFormState.edit &&
        state.editingEmployee != null) {
      nameController.text = state.editingEmployee!.name;
      selectedRole = state.editingEmployee!.position ?? "";
      _fromDate = state.editingEmployee!.dateOfJoining;
      _toDate = state.editingEmployee!.lastWorkingDay;
    } else if (state.formState == EmployeeFormState.add) {
      nameController.clear();
      selectedRole = "";
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
      appBar: AppBar(
        title: Text(_buildAppBarTitle(context)),
        actions: [
          context.watch<EmployeeBloc>().state.formState ==
                  EmployeeFormState.edit
              ? IconButton(
                onPressed: () {
                  context.read<EmployeeBloc>().add(
                    DeleteEmployee(
                      context.read<EmployeeBloc>().state.editingEmployee!.id,
                    ),
                  );
                   context.read<EmployeeBloc>().add(SwitchFormState(formState: EmployeeFormState.list));
                },
                icon: Icon(Icons.delete_forever, color: Colors.white),
              )
              : SizedBox(),
        ],
      ),

      body: BlocListener<EmployeeBloc, EmployeeState>(
        listenWhen:
            (previous, current) =>
                previous.successMessage != current.successMessage ||
                previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            } else if (state.formState == EmployeeFormState.list) {
              return Column(
                children: [
                  Expanded(
                    child: EmployeeList(
                      employees: state.employees,
                      onDismissed: (employee) {
                        context.read<EmployeeBloc>().add(
                          DeleteEmployee(employee.id),
                        );
                      },
                      onTap: (employee) {
                        context.read<EmployeeBloc>().add(
                          SwitchFormState(
                            formState: EmployeeFormState.edit,
                            employee: employee,
                            name: employee.name,
                            selectedRole: employee.position ?? "",
                            dateOfJoining: employee.dateOfJoining,
                          ),
                        );
                      },
                    ),
                  ),
                  state.employees.isNotEmpty
                      ? Container(
                        color: Colors.grey.shade200,
                        height: 80,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Swipe left to delete",style: TextStyle(color: Colors.grey),),
                          ),
                        ),
                      )
                      : SizedBox(),
                ],
              );
            } else {
              return _buildEmployeeForm(context, state);
            }
          },
        ),
      ),

      floatingActionButton:
          context.watch<EmployeeBloc>().state.formState ==
                  EmployeeFormState.list
              ? FloatingActionButton(
                backgroundColor: Colors.blue,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  context.read<EmployeeBloc>().add(
                    SwitchFormState(formState: EmployeeFormState.add),
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
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
 

  // Employee Form (Add/Edit)
  Widget _buildEmployeeForm(BuildContext context, EmployeeState state) {
    return LayoutBuilder(
      builder: (context,constraints) {
         double screenWidth = constraints.maxWidth;
      double horizontalPadding = screenWidth > webWidth ? screenWidth * 0.25 : 16.0;
      double verticalPadding = screenWidth > webWidth ? 50:16;
       bool isWeb = screenWidth > webWidth;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: verticalPadding),
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
                          _openCalendarDialog(false, state);
                        },
                        onToDateTap: () {
                          _openCalendarDialog(true, state);
                        },
                        fromDate: _fromDate,
                        toDate: _toDate,
                      ),
                    
               isWeb
    ? Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          height: _inputFiledheight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50, // Explicitly setting button height
                  child: ElevatedButton(
                    style: webButtonStyle,
                    onPressed: () {
                      context.read<EmployeeBloc>().add(
                        SwitchFormState(formState: EmployeeFormState.list),
                      );
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50, // Explicitly setting button height
                  child: ElevatedButton(
                    style: webButtonStyle,
                    onPressed: () {
                      _saveEmployee(context, state);
                    },
                    child: const Text("Save"),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    : const SizedBox()

                    ],
                  ),
                ),
              ),
            ),
        
           !isWeb? EmployeeFormActions(
              onCancel: () {
                context.read<EmployeeBloc>().add(
                  SwitchFormState(formState: EmployeeFormState.list),
                );
              },
              onSave: () {
                _saveEmployee(context, state);
              },
            ):SizedBox(),
          ],
        );
      }
    );
  }

  

  _employeeNameField() {
    return SizedBox(
      height: _inputFiledheight,

      child: TextFormField(
        controller: nameController,
        cursorHeight: 18,
 inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')), // Allow only letters and spaces
          LengthLimitingTextInputFormatter(30), // Set max length to 30
        ],
        decoration: InputDecoration(
          hintText: "Employee name",
          prefixIcon: const Icon(Icons.person_outline, color: Colors.blue, ),
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
            const Icon(Icons.work_outline, color: Colors.blue),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                selectedRole.isEmpty ? "Select role" : selectedRole,
                style: TextStyle(
                  color: selectedRole == "" ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.blue,size: 30,),
          ],
        ),
      ),
    );
  }

  void _saveEmployee(BuildContext context, EmployeeState state) {
    final name = nameController.text.trim();


    if (name.isEmpty) {
      _showSnackBar(context, "Please enter the employee's name.");
      return;
    }
    if (selectedRole.isEmpty) {
      _showSnackBar(context, "Please select a position.");
      return;
    }

    final employee = EmployeesCompanion(
      id:
          state.editingEmployee != null
              ? Value(state.editingEmployee!.id)
              : const Value.absent(),
      name: Value(name),
      position: Value(selectedRole),
      dateOfJoining: Value(_fromDate ?? DateTime.now()),
     // lastWorkingDay:  Value(null)
      lastWorkingDay: _toDate != null ? Value(_toDate!) : const Value(null),
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  

  void _openCalendarDialog(bool toDate, EmployeeState state) {
  showDialog(
    context: context,
    builder: (context) {
      return CalendarDialog(
       // allowPast: state.formState == EmployeeFormState.edit,
        disableDay: state.formState == EmployeeFormState.edit
            ? _fromDate
            : (toDate ? _fromDate : null),
        toDate: toDate,
        selectedDay: toDate
            ? _toDate ?? _fromDate ?? DateTime.now()
            : _fromDate ?? DateTime.now(),
        onDateSelected: (newDate) {
          if (state.formState == EmployeeFormState.edit && newDate == null) {
            // Allow setting 'To Date' to null in edit mode
            setState(() {
              if (toDate) {
                _toDate = null;
              } else {
                _fromDate = null;
              }
            });
            return;
          }

          if (newDate == null) return;

          final today = DateTime.now();
          final selectedDate = DateTime(newDate.year, newDate.month, newDate.day);
          final minAllowedDate = DateTime(today.year, today.month, today.day); // Remove time

          if (selectedDate.isBefore(minAllowedDate) && state.formState != EmployeeFormState.edit) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You cannot select past dates")),
            );
            return;
          }

          if (toDate && _fromDate != null && selectedDate.isBefore(_fromDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("To Date cannot be before From Date")),
            );
            return;
          }

          setState(() {
            if (toDate) {
              _toDate = selectedDate;
            } else {
              _fromDate = selectedDate;
              if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
                _toDate = null; // Reset To Date if it's invalid
              }
            }
          });
        },
      );
    },
  );
}

}
