import 'package:employee_record/presentation/core/utils/date_utils.dart';
import 'package:flutter/material.dart';



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
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Dynamic Sizes Based on Screen Width
   double inputFieldHeight = (screenWidth * 0.10).clamp(40.0, 45.0);

    double iconSize = screenWidth * 0.04; // 4% of screen width
    double fontSize = screenWidth * 0.04; // 4% of screen width
    double spacing = screenWidth * 0.02; // 2% of screen width

    return SizedBox(
      height: inputFieldHeight,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onFromDateTap,
              child: Container(
                height: inputFieldHeight,
                padding: EdgeInsets.symmetric(horizontal: spacing * 1.5, vertical: spacing),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: iconSize),
                    SizedBox(width: spacing),
                    Text(
                      fromDate != null ? formatDate(fromDate!) : "Today",
                      style: TextStyle(fontSize: fontSize, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: spacing * 2),
          Icon(Icons.arrow_forward, color: Colors.blue, size: iconSize),
          SizedBox(width: spacing * 2),
          Expanded(
            child: GestureDetector(
              onTap: onToDateTap,
              child: Container(
                height: inputFieldHeight,
                padding: EdgeInsets.symmetric(horizontal: spacing * 1.5, vertical: spacing),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: iconSize),
                    SizedBox(width: spacing),
                    FittedBox(
                      child: Text(
                        maxLines: 1,
                        toDate != null ? formatDate(toDate!) : "No date",
                        style: TextStyle(fontSize: fontSize),
                      ),
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

