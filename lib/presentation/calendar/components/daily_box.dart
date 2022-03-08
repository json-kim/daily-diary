import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class DailyBox extends StatelessWidget {
  final Color color;
  final Function()? onTap;
  final String? label;
  final DateTime? date;

  DailyBox({
    required this.color,
    required this.onTap,
    required this.label,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: date?.isSameDay(DateTime.now()) ?? false
              ? Border.all(color: Colors.black)
              : null,
        ),
        child: label != null
            ? Center(
                child: Text(label!),
              )
            : Container(),
      ),
    );
  }
}
