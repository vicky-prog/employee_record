import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

double _defaultPadding = 14;

class CalendarDialog extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime? disableDay;
  final Function(DateTime?) onDateSelected;
  bool? toDate;
  bool? allowPast;
  CalendarDialog({
    super.key,
    required this.selectedDay,
    required this.onDateSelected,
    this.toDate = false,
    this.disableDay,
    this.allowPast = false
  });

  @override
  // ignore: library_private_types_in_public_api
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = (widget.toDate ?? false) ? null : widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 12, right: 12),
          backgroundColor: Colors.white,
        
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
               constraints: BoxConstraints(
          maxWidth: 500, // Adjust width dynamically
        ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick Select Buttons
                Padding(
                  padding:  EdgeInsets.only(left: _defaultPadding, right: _defaultPadding, top: _defaultPadding),
                  child: Column(
                    children: [
                      widget.toDate ?? false
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(child: _quickSelectButton("No Date", null)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _quickSelectButton("Today", DateTime.now()),
                                ),
                              ],
                            ),
                          )
                          : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _quickSelectButton(
                                      "Today",
                                      DateTime.now(),
                                    ),
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
                              SizedBox(height: 10),
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
                    
                                      DateTime.now().add(Duration(days: 7)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
                    
                SizedBox(height: 16),
                // Calendar Widget
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: _defaultPadding),
                  child: TableCalendar(
                              
                    focusedDay: _selectedDay ?? DateTime.now(),
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
                    // Disable past dates
                    enabledDayPredicate: (day) {
                      if(widget.allowPast!){
                       return true;
                      }
                      var today = DateTime.now();
                      if(widget.disableDay != null){
                         today = widget.disableDay!;
                      }
                      return !day.isBefore(
                        DateTime(today.year, today.month, today.day),
                      ); // Allow today & future
                    },
                      
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronMargin: EdgeInsets.only(left: 30),
                      rightChevronMargin: EdgeInsets.only(right: 30),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                    ),
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      
                      setState(() => _selectedDay = selectedDay);
                    },
                  ),
                ),
                Divider(color: Colors.grey.shade300,thickness: 0.8,),
                Padding(
                  padding:  EdgeInsets.only(left: _defaultPadding,right: _defaultPadding,bottom: _defaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                _selectedDay == null
                                    ? "No Date"
                                    : DateFormat('d MMM yyyy').format(_selectedDay!),
                                style: TextStyle(
                                  fontSize: 15,
                                 // fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                      Expanded(
                        child: SizedBox(
                         // height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _actionButton(
                                      "Cancel",
                                      Colors.blue.shade50,
                                      Colors.blue,
                                      () => Navigator.pop(context),
                                    ),
                                    SizedBox(width: 10),
                                    _actionButton(
                                      "Save",
                                      Colors.blue,
                                      Colors.white,
                                      () {
                                        if (_selectedDay != null) {
                                          widget.onDateSelected(_selectedDay!);
                                        } else {
                                          widget.onDateSelected(null);
                                        }
                    
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _quickSelectButton(String label, DateTime? date) {
    bool isSelected =
        date == null ? _selectedDay == null : isSameDay(date, _selectedDay);

    return ElevatedButton(
      onPressed:
          () => setState(() {
            _selectedDay = date;
          }),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade50,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _actionButton(
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, maxLines: 1),
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
