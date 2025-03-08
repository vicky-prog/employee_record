import 'package:flutter/material.dart';

double _inputFieldHeight = 45;

class DateSelectionRow extends StatelessWidget {
  final VoidCallback onFromDateTap;
  final VoidCallback onToDateTap;
  final DateTime? fromDate;
  final DateTime? toDate;
  
  final double borderRadius;

  const DateSelectionRow({
    super.key,
    required this.onFromDateTap,
    required this.onToDateTap,
    required this.fromDate,
    required this.toDate,
   
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _inputFieldHeight,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onFromDateTap,
              child: Container(
                height: _inputFieldHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      fromDate != null
                          ? "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}"
                          : "Today",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: onToDateTap,
              child: Container(
                height: _inputFieldHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      toDate != null
                          ? "${toDate!.day}/${toDate!.month}/${toDate!.year}"
                          : "No date",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
