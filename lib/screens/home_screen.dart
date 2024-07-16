import 'package:flutter/material.dart';
import 'package:autobio/screens/diary_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../profile_screen.dart';
import '../providers/api_providers.dart';
import '../providers/book_provider.dart';
import '../providers/user_provider.dart';
import 'diaryscreen.dart';
import 'new_diary_entry_screen.dart';
import '../CustomPageRoute.dart';
import '../helpers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipping = false;
  int _selectedDiaryIndex = 0;
  Color _selectedDiaryColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    final user = ref.read(userProvider);
    if (user != null) {
      ref.read(bookProvider.notifier).setUserId(user.userId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNewDiaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDiaryDialog();
      },
    );
  }

  void _flipDiary(int index, Book book) {
    setState(() {
      _isFlipping = true;
      _selectedDiaryIndex = index;
      _selectedDiaryColor = Color(int.parse(book.book_cover_image));
    });
    _controller.forward().then((_) {
      Navigator.of(context).push(
        CustomPageRoute(
          page: DiaryScreen(backgroundColor: _selectedDiaryColor,bookId: book.book_id!),
          backgroundColor: _selectedDiaryColor,
        ),
      ).then((_) {
        _controller.reset();
        setState(() {
          _isFlipping = false;
        });
      });
    });
  }
  void _deleteDiary(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Diary'),
          content: Text('Are you sure you want to delete this diary?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(bookProvider.notifier).removeBook(bookId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final books = ref.watch(bookProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Diary',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onPressed: _showNewDiaryDialog,
              ),
            ],
          ),
        ),
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () => _flipDiary(index, book),
                    onLongPress: () => _deleteDiary(context, book.book_id!), // Long press to delete
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        double angle = _animation.value * 3.1415927 / 2;
                        if (_isFlipping && _selectedDiaryIndex == index) {
                          if (angle > 1.5708) {
                            angle = 3.1415927 / 2 - angle;
                          }
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // Perspective
                              ..rotateY(angle),
                            alignment: Alignment.center,
                            child: _animation.value > 0.5
                                ? Container(
                              width: 160,
                              height: 240,
                              color: Colors.transparent,
                            )
                                : child,
                          );
                        }
                        return child!;
                      },
                      child: DiaryCard(
                        color: Color(int.parse(book.book_cover_image)),
                        title: book.book_title,
                        year: book.book_creation_day.split('-')[0],
                        theme: book.book_theme,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Write down today's text\nTell your story.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
class NewDiaryDialog extends ConsumerStatefulWidget {
  @override
  _NewDiaryDialogState createState() => _NewDiaryDialogState();
}

class _NewDiaryDialogState extends ConsumerState<NewDiaryDialog> {
  final _nameController = TextEditingController();
  final _themeController = TextEditingController();
  Color _selectedColor = Colors.orange;

  void _addBook(BuildContext context) async {
    final user = ref.watch(userProvider);
    if (user == null) {
      return;
    }
    final newBook = Book(
      book_title: _nameController.text,
      book_cover_image: _selectedColor.value.toString(),
      page_list: [],
      book_creation_day: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      owner_user: user.userId,
      book_private: false,
      book_theme: _themeController.text,
    );

    print('Adding book: ${newBook.book_title}'); // 로그 추가

    final createdBook = await ref.read(bookProvider.notifier).addBook(newBook);
    Navigator.of(context).pop(); // 다이얼로그 닫기
    print('Created BookID: ${createdBook.book_id}'); // 로그 추가
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Diary'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _themeController,
              decoration: InputDecoration(labelText: 'Theme'),
            ),
            SizedBox(height: 16.0),
            Text('Select Cover Color:'),
            GestureDetector(
              onTap: () {
                _pickColor(context);
              },
              child: Container(
                width: 50,
                height: 50,
                color: _selectedColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addBook(context);
          },
          child: Text('Create'),
        ),
      ],
    );
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

