import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/page_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int index;
  final Color backgroundColor;
  final String bookId;
  final String pageId;

  DetailScreen({required this.index, required this.backgroundColor,required this.bookId,required this.pageId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  DateTime? _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    final page = ref.read(pageProvider).firstWhere((page) => page.page_id == widget.pageId);
    _titleController = TextEditingController(text: page.page_title);
    _contentController = TextEditingController(text: page.page_content);
    _selectedDate=DateTime.parse(page.page_creation_day);
  }

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
  void _savePage() {
    final page = ref.read(pageProvider).firstWhere((page) => page.page_id == widget.pageId);
    final updatedPage = page.copyWith(
      page_title: _titleController.text,
      page_content: _contentController.text,
      page_creation_day: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : page.page_creation_day,
    );
    ref.read(pageProvider.notifier).updatePage(page.page_id!, {
      'page_title': updatedPage.page_title,
      'page_content': updatedPage.page_content,
      'page_creation_day': updatedPage.page_creation_day,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(pageProvider);
    if (pages.isEmpty || widget.index >= pages.length) {
      return Scaffold(
        body: Center(
          child: Text('Page not found', style: TextStyle(color: Colors.red, fontSize: 24)),
        ),
      );
    }

    final page = pages.firstWhere((page) => page.page_id == widget.pageId);

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
          '${widget.index+1} 번째 이야기',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _savePage,
            child: Text(
              '저장',
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
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      fontFamily: 'MaruBuri',
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthYear,
                        style: TextStyle(fontSize: 18, color: Colors.grey,fontFamily: 'MaruBuri'),
                      ),
                      Text(
                        weekday,
                        style: TextStyle(fontSize: 18, color: Colors.grey,fontFamily: 'MaruBuri'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: TextStyle(color: widget.backgroundColor, fontSize: 20, fontWeight: FontWeight.w800,fontFamily: 'MaruBuri',),
              maxLines: null,
            ),
            SizedBox(height: 5.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w400,fontFamily: 'MaruBuri'),
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
