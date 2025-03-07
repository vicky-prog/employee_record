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
      backgroundColor: Colors.white,
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
                Row(
                  children: [
                    Expanded(
                      child: _quickSelectButton("Today", DateTime.now()),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _quickSelectButton(
                        "Next Monday",
                        _getNextMonday(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _quickSelectButton(
                        "Next Tuesday",
                        _getNextTuesday(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _quickSelectButton(
                        "After 1 Week",
                        _selectedDay.add(Duration(days: 7)),
                      ),
                    ),
                  ],
                ),
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
          Divider(),
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
            
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue,size: 20,),
                      SizedBox(width: 3),
                      Text(
                        DateFormat('d MMM yyyy').format(_selectedDay),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                1,
                              ), // Adjust the radius as needed
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              "Cancel",
                              maxLines: 1,
                              style: TextStyle(),
                            ),
                          ),
                        ),
                      ),
                                    
                      SizedBox(width: 10),
                       Expanded(
                         child: ElevatedButton(
                          onPressed: () {
                              widget.onDateSelected(_selectedDay);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                1,
                              ), // Adjust the radius as needed
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              "Save",
                              maxLines: 1,
                              style: TextStyle(),
                            ),
                          ),
                                               ),
                       ),
                     
                    ],
                  ),
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
        elevation: 0,
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1), // Adjust the radius as needed
        ),
      ),
      child: FittedBox(child: Text(label, maxLines: 1, style: TextStyle())),
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
    return now.add(
      Duration(days: daysUntilTuesday == 0 ? 7 : daysUntilTuesday),
    );
  }
}
