import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final int index;
  final Color backgroundColor;

  DetailScreen({required this.index, required this.backgroundColor});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String day = _selectedDate != null ? DateFormat.d().format(_selectedDate!) : '20';
    final String monthYear = _selectedDate != null ? DateFormat.yMMMM().format(_selectedDate!) : 'May 2019';
    final String weekday = _selectedDate != null ? DateFormat.EEEE().format(_selectedDate!) : 'Monday';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthYear,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        weekday,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Detail Page for Section ${widget.index + 1}',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.grey.withOpacity(0.3)),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
