import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';



class CalendarDialog extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onDateSelected;

  const CalendarDialog({
    super.key,
    required this.selectedDay,
    required this.onDateSelected,
  });

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Select Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  _quickSelectButton("Today", DateTime.now()),
                  _quickSelectButton("Next Monday", _getNextMonday()),
                ]),
                Row(children: [
                  _quickSelectButton("Next Tuesday", _getNextTuesday()),
                  _quickSelectButton("After 1 Week", _selectedDay.add(Duration(days: 7))),
                ]),
              ],
            ),
          ),
          // Calendar Widget
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
               leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black), 
               rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black), 
            ),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          // Bottom Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue),
                    SizedBox(width: 5),
                    Text(
                      DateFormat('d MMM yyyy').format(_selectedDay),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        widget.onDateSelected(_selectedDay);
                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickSelectButton(String label, DateTime date) {
    bool isSelected = isSameDay(date, _selectedDay);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDay = date;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
      ),
      child: Text(label),
    );
  }

  DateTime _getNextMonday() {
    DateTime now = DateTime.now();
    int daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    int daysUntilTuesday = (DateTime.tuesday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilTuesday == 0 ? 7 : daysUntilTuesday));
  }
}
