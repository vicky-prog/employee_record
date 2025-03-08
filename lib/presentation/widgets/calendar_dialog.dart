import 'package:employee_record/presentation/pages/employee_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

double _defaultPadding = 14;





class CalendarDialog extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime? disableDay;
  final Function(DateTime?) onDateSelected;
  final bool toDate;
  final bool allowPast;

  const CalendarDialog({
    super.key,
    required this.selectedDay,
    required this.onDateSelected,
    this.toDate = false,
    this.disableDay,
    this.allowPast = false,
  });

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.toDate ? null : widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > webWidth;
        double paddingValue = isWeb ? _defaultPadding * 2 : _defaultPadding;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: constraints.maxHeight * 0.9,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: paddingValue,right: paddingValue,top: paddingValue),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQuickSelectButtons(isWeb),
                        const SizedBox(height: 16),
                        _buildCalendar(),
                       
                      ],
                    ),
                  ),
                    Divider(color: Colors.grey.shade300, thickness: 0.8),
                        _buildBottomActions(context, paddingValue),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSelectButtons(bool isWeb) {
    return Column(
      children: [
        widget.toDate
            ? Row(
                children: [
                  Expanded(child: _quickSelectButton("No Date", null)),
                  const SizedBox(width: 10),
                  Expanded(child: _quickSelectButton("Today", DateTime.now())),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _quickSelectButton("Today", DateTime.now())),
                      const SizedBox(width: 10),
                      Expanded(child: _quickSelectButton("Next Monday", _getNextMonday())),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _quickSelectButton("Next Tuesday", _getNextTuesday())),
                      const SizedBox(width: 10),
                      Expanded(child: _quickSelectButton("After 1 Week", DateTime.now().add(const Duration(days: 7)))),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _selectedDay ?? DateTime.now(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
        selectedDecoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      ),
      enabledDayPredicate: (day) {
        if (widget.allowPast) return true;
        var today = widget.disableDay ?? DateTime.now();
        return !day.isBefore(DateTime(today.year, today.month, today.day));
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _selectedDay = selectedDay);
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, double paddingValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingValue , vertical: _defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                const SizedBox(width: 5),
                Text(
                  _selectedDay == null ? "No Date" : DateFormat('d MMM yyyy').format(_selectedDay!),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _actionButton("Cancel", Colors.blue.shade50, Colors.blue, () => Navigator.pop(context)),
              const SizedBox(width: 10),
              _actionButton("Save", Colors.blue, Colors.white, () {
                widget.onDateSelected(_selectedDay);
                Navigator.pop(context);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickSelectButton(String label, DateTime? date) {
    bool isSelected = date == null ? _selectedDay == null : isSameDay(date, _selectedDay);

    return ElevatedButton(
      onPressed: () => setState(() => _selectedDay = date),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? Colors.blue : Colors.blue.shade50,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _actionButton(String label, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

