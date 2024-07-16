import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDiaryEntryScreen extends StatefulWidget {
  final Color backgroundColor;
  NewDiaryEntryScreen({required this.backgroundColor});

  @override
  _NewDiaryEntryScreenState createState() => _NewDiaryEntryScreenState();
}

class _NewDiaryEntryScreenState extends State<NewDiaryEntryScreen> {
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: widget.backgroundColor,
        title: Text(
          '새 글 쓰기',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save the diary entry and navigate back
              Navigator.pop(context);
            },
            child: Text(
              '전송',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
                  hintText: 'Write your diary here...',
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
