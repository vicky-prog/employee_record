import 'package:drift/drift.dart';
import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:employee_record/presentation/pages/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum EmployeeFormState { list, add, edit }

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
                      // 🔹 Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<EmployeeBloc>().add(
                            DeleteEmployee(employee.id),
                          );
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
}
