import 'package:drift/drift.dart' show Value;
import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController _nameController = TextEditingController();

  String selectedRole = "Select role";

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Employee Details")),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Employee Name Field
            SizedBox(
              height: 45, // Exact height
              child: TextFormField(
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
                      onTap: () {},
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
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
                      onTap: () {},
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {}, // Handle Cancel
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
                      onPressed: _addEmployee,
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
      ),
    );
  }

  _addEmployee() {
    final newEmployee = EmployeesCompanion(
      name: Value(_nameController.text),
      position: Value(selectedRole),
      dateOfJoining: Value(DateTime.now()),
    );
    context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
    Navigator.pop(context);
  }
}
