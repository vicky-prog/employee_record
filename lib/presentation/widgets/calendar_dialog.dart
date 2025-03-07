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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick Select Buttons
            Row(
              children: [
                Expanded(child: _quickSelectButton("Today", DateTime.now())),
                SizedBox(width: 10),
                Expanded(child: _quickSelectButton("Next Monday", _getNextMonday())),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _quickSelectButton("Next Tuesday", _getNextTuesday())),
                SizedBox(width: 10),
                Expanded(child: _quickSelectButton("After 1 Week", _selectedDay.add(Duration(days: 7)))),
              ],
            ),
            SizedBox(height: 16),
            // Calendar Widget
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
              ),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() => _selectedDay = selectedDay);
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                        SizedBox(width: 5),
                        Text(
                          DateFormat('d MMM yyyy').format(_selectedDay),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  _actionButton("Cancel", Colors.blue.shade100, Colors.blue, () => Navigator.pop(context)),
                  SizedBox(width: 10),
                  _actionButton("Save", Colors.blue, Colors.white, () {
                    widget.onDateSelected(_selectedDay);
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickSelectButton(String label, DateTime date) {
    bool isSelected = isSameDay(date, _selectedDay);
    return ElevatedButton(
      onPressed: () => setState(() => _selectedDay = date),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _actionButton(String label, Color bgColor, Color textColor, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, maxLines: 1),
      ),
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
