import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/presentation/widgets/employee_card.dart';
import 'package:employee_record/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;
  final ValueChanged<Employee> onDismissed;
  final ValueChanged<Employee> onTap;

  const EmployeeList({
    super.key,
    required this.employees,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentEmployees =
        employees.where((e) => e.lastWorkingDay == null).toList();
    final previousEmployees =
        employees.where((e) => e.lastWorkingDay != null).toList();

    if (employees.isEmpty) {
      return Center(
        child: Image.asset('assets/images/no_record.png', height: 150),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(thickness: 0.5, height: 0.8, color: Colors.grey.shade300),
      itemCount: currentEmployees.length + previousEmployees.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SectionHeader(title: "Current Employees");
        } else if (index <= currentEmployees.length) {
          return InkWell(
            onTap: () {
              onTap(currentEmployees[index - 1]);
            },
            child: EmployeeCard(
              employee: currentEmployees[index - 1],
              onDismissed: () {
                onDismissed(currentEmployees[index - 1]);
              },
            ),
          );
        } else if (index == currentEmployees.length + 1) {
          return const SectionHeader(title: "Previous Employees");
        } else {
          final previousIndex = index - currentEmployees.length - 2; // Adjust index
          return InkWell(
            onTap: () {
              onTap(previousEmployees[previousIndex]);
            },
            child: EmployeeCard(
              employee: previousEmployees[previousIndex],
              onDismissed: () {
                onDismissed(previousEmployees[previousIndex]);
              },
            ),
          );
        }
      },
    );
  }
}


