import 'package:drift/drift.dart' show Value;
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:employee_record/presentation/widgets/calendar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_record/data/local/database/app_database.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String selectedRole = "Select role";
  DateTime _selectedDay = DateTime.now();
 final TextEditingController nameController = TextEditingController(
     
    );
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
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_){
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
      
     floatingActionButton: context.watch<EmployeeBloc>().state.formState == EmployeeFormState.list
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
        return "Employee Records";
      case EmployeeFormState.add:
        return "Add Employee";
      case EmployeeFormState.edit:
        return "Edit Employee";
      default:
        return "Employee Records";
    }
  }

  // ✅ Employee List View
  Widget _buildEmployeeList(BuildContext context, EmployeeState state) {
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
                      dateOfJoining: employee.dateOfJoining
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

  // ✅ Employee Form (Add/Edit)
  Widget _buildEmployeeForm(BuildContext context, EmployeeState state) {
  // nameController.text = state.name;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 45, // Exact height
            child: TextFormField(
              controller: nameController,
              cursorHeight: 18,
              decoration: InputDecoration(
                hintText: "Employee name",
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Select Role Field (Clickable)
          GestureDetector(
            onTap: _showRoleBottomSheet,
            child: Container(
              width: double.infinity,
              height: 45, // Adjusted for better UX
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
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
          ),
          SizedBox(height: 20),
          // Date Selection Row
          SizedBox(
            height: 45, // Fixed height
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _openCalendarDialog(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white, // Match background
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align text & icon
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(width: 8), // Adjusted spacing
                          Text(
                            "Today",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Gap of 16px
                Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
                SizedBox(width: 16), // Gap of 16px
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                        _openCalendarDialog(true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white, // Match background
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align text & icon
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(width: 8), // Adjusted spacing
                          Text(
                            "No date",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Light shadow
                  blurRadius: 4, // Softness of the shadow
                  offset: Offset(0, -2), // Shadow direction (top side)
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                       context.read<EmployeeBloc>().add(
      SwitchFormState(formState: EmployeeFormState.list),
    );
                    }, // Handle Cancel
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue, // Text color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final employee = EmployeesCompanion(
                        id:
                            state.editingEmployee != null
                                ? Value(
                                  state.editingEmployee!.id,
                                ) // ✅ Preserve ID for updates
                                : const Value.absent(), // ✅ Auto-increment for new entries
                        name: Value(nameController.text),
                        position: Value(selectedRole),
                        dateOfJoining: Value(DateTime.now()),
                      );

                      if (state.formState == EmployeeFormState.add) {
                        context.read<EmployeeBloc>().add(AddEmployee(employee));
                      } else {
                        context.read<EmployeeBloc>().add(
                          UpdateEmployee(employee),
                        );
                      }

                      context.read<EmployeeBloc>().add(
                        SwitchFormState(formState: EmployeeFormState.list),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
     
        ],
      ),
    );
  }

   void _openCalendarDialog(bool toDate) {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(
          toDate: toDate,
          selectedDay: _selectedDay,
          onDateSelected: (newDate) {
            setState(() {
              _selectedDay = newDate;
            });
          },
        );
      },
    );
  }
}
