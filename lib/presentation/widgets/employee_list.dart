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

    final bool showCurrentSection = currentEmployees.isNotEmpty;
    final bool showPreviousSection = previousEmployees.isNotEmpty;

    final int totalItems = currentEmployees.length +
        previousEmployees.length +
        (showCurrentSection ? 1 : 0) +
        (showPreviousSection ? 1 : 0);

    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(thickness: 0.5, height: 0.8, color: Colors.grey.shade300),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        int adjustedIndex = index;
        
        // Show "Current Employees" header if needed
        if (showCurrentSection) {
          if (index == 0) return const SectionHeader(title: "Current Employees");
          adjustedIndex--;
        }

        // Show current employees
        if (adjustedIndex < currentEmployees.length) {
          return InkWell(
            onTap: () {
              onTap(currentEmployees[adjustedIndex]);
            },
            child: EmployeeCard(
              employee: currentEmployees[adjustedIndex],
              onDismissed: () {
                onDismissed(currentEmployees[adjustedIndex]);
              },
            ),
          );
        }
        adjustedIndex -= currentEmployees.length;

        // Show "Previous Employees" header if needed
        if (showPreviousSection) {
          if (adjustedIndex == 0) return const SectionHeader(title: "Previous Employees");
          adjustedIndex--;
        }

        // Show previous employees
        return InkWell(
          onTap: () {
            onTap(previousEmployees[adjustedIndex]);
          },
          child: EmployeeCard(
            employee: previousEmployees[adjustedIndex],
            onDismissed: () {
              onDismissed(previousEmployees[adjustedIndex]);
            },
          ),
        );
      },
    );
  }
}



