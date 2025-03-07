import 'package:drift/drift.dart';
import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:employee_record/presentation/pages/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🔹 Load employees when screen is built
    context.read<EmployeeBloc>().add(LoadEmployees());

    return Scaffold(
      appBar: AppBar(title: Text("Employees")),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            return ListView.builder(
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text(employee.position.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, employee);
                        },
                      ),
                      // 🔹 Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<EmployeeBloc>().add(DeleteEmployee(employee.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("No employees available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // _showAddDialog(context);
                          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AddEmployeePage()),
);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 🔹 Function to show add employee dialog
  void _showAddDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController positionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Employee"),
          content: Wrap(
           // mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: positionController, decoration: InputDecoration(labelText: "Position")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {


                final newEmployee = EmployeesCompanion(
                  name: Value(nameController.text),
                  position: Value(positionController.text),
                  dateOfJoining: Value(DateTime.now()),
                );
                context.read<EmployeeBloc>().add(AddEmployee(newEmployee));
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Function to show edit employee dialog
  void _showEditDialog(BuildContext context, Employee employee) {
    TextEditingController nameController = TextEditingController(text: employee.name);
    TextEditingController positionController = TextEditingController(text: employee.position);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Employee"),
          content: Wrap(
            //mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: positionController, decoration: InputDecoration(labelText: "Position")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedEmployee = employee.copyWith(
                  name: nameController.text,
                  position: Value(positionController.text),
                );
                context.read<EmployeeBloc>().add(UpdateEmployee(updatedEmployee));
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
