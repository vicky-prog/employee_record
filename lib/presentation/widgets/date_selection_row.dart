import 'package:employee_record/presentation/core/utils/date_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:employee_record/presentation/core/utils/date_utils.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double inputFieldHeight = (screenWidth * 0.08).clamp(40.0, 50.0);
        double iconSize = (screenWidth * 0.03).clamp(15, 22);
        double fontSize = (screenWidth * 0.040).clamp(12, 16);
        double spacing = screenWidth * 0.015; // Adjust based on screen size

        return SizedBox(
          height: inputFieldHeight,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // From Date Field
              Expanded(
                child: GestureDetector(
                  onTap: onFromDateTap,
                  child: Container(
                    height: inputFieldHeight,
                    padding: EdgeInsets.symmetric(horizontal: spacing * 1.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue, size: iconSize),
                        SizedBox(width: spacing),
                        Expanded(
                          child: Text(
                            fromDate != null ? formatDate(fromDate!) : "Today",
                            style: TextStyle(fontSize: fontSize, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: spacing * 2),
              
              // Arrow Icon
              Icon(Icons.arrow_forward, color: Colors.blue, size: iconSize),
              
              SizedBox(width: spacing * 2),
              
              // To Date Field
              Expanded(
                child: GestureDetector(
                  onTap: onToDateTap,
                  child: Container(
                    height: inputFieldHeight,
                    padding: EdgeInsets.symmetric(horizontal: spacing * 1.5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue, size: iconSize),
                        SizedBox(width: spacing),
                        Expanded(
                          child: Text(
                            toDate != null ? formatDate(toDate!) : "No date",
                            style: TextStyle(fontSize: fontSize, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}

