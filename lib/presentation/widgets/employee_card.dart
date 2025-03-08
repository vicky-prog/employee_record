import 'package:employee_record/data/local/database/app_database.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


const sizedBoxSpacing = SizedBox(height: 5);
class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onDismissed;

  const EmployeeCard({super.key, required this.employee, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(employee.name), 
      direction: DismissDirection.endToStart, // Swipe left to delete
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismissed(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.name.capitalizeFirst(), style: const TextStyle(fontWeight: FontWeight.bold)),
            sizedBoxSpacing,
            Text(employee.position ?? ""),
            sizedBoxSpacing,
             Text(
              employee.lastWorkingDay == null
                  ? "From ${formatDate(employee.dateOfJoining)}"
                  : "${formatDate(employee.dateOfJoining!)} - ${formatDate(employee.lastWorkingDay!)}",
              style: const TextStyle(color: Colors.grey,fontSize: 12),)
          
          ],
        ),
      ),
    );
  }

   String formatDate(DateTime date) {
    return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
  }

  String _getMonthName(int month) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month];
  }
}
