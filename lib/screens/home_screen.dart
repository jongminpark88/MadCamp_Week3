import 'package:flutter/material.dart';
import 'package:autobio/screens/diary_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../profile_screen.dart';
import '../providers/api_providers.dart';
import '../providers/user_provider.dart';
import 'diaryscreen.dart';
import 'new_diary_entry_screen.dart';
import '../CustomPageRoute.dart';
import '../helpers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;
  int _selectedDiaryIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showNewDiaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDiaryDialog(
          onCreate: (String name, String theme, Color color) {
            // 새로운 다이어리 생성 로직을 여기에 추가하세요.
            print('New Diary - Name: $name, Theme: $theme, Color: $color');
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userBooksAsyncValue = ref.watch(userBooksProvider(user.userId));

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
      body: userBooksAsyncValue.when(
        data: (books) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0), // 상단 패딩 조정
              ),
              Expanded(
                flex: 50, // 책 리스트 공간을 더 늘림
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: books.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedDiaryIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final book = books[index];
                    bool isSelected = index == _selectedDiaryIndex;

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CustomPageRoute(
                            page: DiaryScreen(backgroundColor: Color(int.parse(book.book_cover_image))),
                            backgroundColor: Color(int.parse(book.book_cover_image)),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(vertical: isSelected ? 90 : 90, horizontal: 10),
                        child: Transform.scale(
                          scale: isSelected ? 1.5 : 0.9, // 가운데 책이 더 커지도록 조정하고 양옆 책의 크기를 줄임
                          child: DiaryCard(
                            color: Color(int.parse(book.book_cover_image)),
                            title: book.book_title,
                            year: book.book_creation_day.split('-')[0],
                            theme: book.book_theme,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Spacer(flex: 1,), // 하단 공간 추가
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Write down today's text\nTell your story.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class NewDiaryDialog extends ConsumerStatefulWidget {
  final void Function(String name, String theme, Color color) onCreate;

  NewDiaryDialog({required this.onCreate});

  @override
  _NewDiaryDialogState createState() => _NewDiaryDialogState();
}

class _NewDiaryDialogState extends ConsumerState<NewDiaryDialog> {
  final _nameController = TextEditingController();
  final _themeController = TextEditingController();
  Color _selectedColor = Colors.orange;

  void _addBook(BuildContext context) async {
    final User? user = ref.read(userProvider);
    if (user == null) return;

    final addBook = ref.read(addBookProvider);
    final newBook = Book(// bookId는 서버에서 생성된다고 가정
      book_title: _nameController.text,
      book_cover_image: _selectedColor.value.toString(),
      page_list: [],
      book_creation_day: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      owner_user: user.userId,
      book_private: false,
      book_theme: _themeController.text,
    );

    await addBook(newBook);

    // 책 추가 후 콜백 호출 및 다이얼로그 닫기
    widget.onCreate(_nameController.text, _themeController.text, _selectedColor);
    Navigator.of(context).pop(); // 다이얼로그 닫기
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
            Wrap(
              spacing: 8.0,
              children: Colors.primaries.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.black : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
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
        ElevatedButton(
          onPressed: () {
            _addBook(context);
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
