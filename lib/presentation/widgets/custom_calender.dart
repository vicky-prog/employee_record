import 'package:flutter/material.dart';
import '../widgets/calendar_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  void _openCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Calendar Dialog")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openCalendarDialog,
          child: Text("Select Date"),
        ),
      ),
    );
  }
}
