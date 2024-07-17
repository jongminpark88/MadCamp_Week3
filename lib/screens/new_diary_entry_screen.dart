import 'package:autobio/providers/book_provider.dart';
import 'package:autobio/screens/generatestoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/page.dart' as models;
import '../providers/page_provider.dart';
import '../providers/user_provider.dart';

class NewDiaryEntryScreen extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final String bookId; // Add bookId to the constructor

  NewDiaryEntryScreen({required this.backgroundColor, required this.bookId});

  @override
  _NewDiaryEntryScreenState createState() => _NewDiaryEntryScreenState();
}

class _NewDiaryEntryScreenState extends ConsumerState<NewDiaryEntryScreen> {
  DateTime _selectedDate = DateTime.now(); // 기본값을 오늘 날짜로 설정
  //final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveDiaryEntry(BuildContext context) async {
    if (_contentController.text.isEmpty) {
      // 내용이 비어 있는 경우 경고 메시지 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('경고'),
          content: Text('일기 내용을 입력해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    final user = ref.read(userProvider);
    final books = ref.read(bookProvider);
    final book = books.firstWhere((book) => book.book_id == widget.bookId);
    if (user == null || book == null) {
      return;
    }

    final newPage = models.Page(
      page_id: '', // This will be replaced by MongoDB's generated ID
      page_title: '',
      page_content: _contentController.text,
      page_creation_day: DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now()),
      owner_book: widget.bookId,
      owner_user: user.userId,
      book_theme: book.book_theme, // Add the appropriate book theme if necessary
    );

    final createdPage = await ref.read(pageProvider.notifier).addPage(newPage);
    Navigator.of(context).pop(); // Close the screen after saving
    print('Created PageID: ${createdPage.page_id}'); // Add a log
  }

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat.d().format(_selectedDate);
    final String monthYear = DateFormat.yMMMM().format(_selectedDate);
    final String weekday = DateFormat.EEEE().format(_selectedDate);

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
            onPressed: () => _saveDiaryEntry(context), // Save the diary entry
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
            Text(
              'AI가 자동으로 제목을 지어줍니다',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '소설 같은 일상을 기록해주세요...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.grey.withOpacity(0.7)),
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
