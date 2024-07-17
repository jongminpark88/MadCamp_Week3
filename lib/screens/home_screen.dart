import 'dart:math'; // 추가된 부분
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
import 'profile_card.dart'; // ProfileCard 위젯을 import

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;
  int _selectedDiaryIndex = 0;
  late String _selectedQuote; // 추가된 부분

  final List<String> _quotes = [ // 추가된 부분
    "삶이란 누구나 한 권의 책을 써 내려가는 것이다.\n - 앙드레 지드 -",
    "인생은 스스로 만드는 소설이다.\n - 나폴레옹 힐 -",
    "기억은 우리의 일기장이다.\n - 오스카 와일드 -",
    "하루를 소설처럼 살아라.\n - 레프 톨스토이 -",
    "우리가 사는 삶은 우리가 써 내려가는 이야기다.\n - 존 그린 -",
    "우리가 지나가는 모든 순간이 언젠가는 추억이 된다.\n - 마크 트웨인 -",
    "소설처럼 인생도 때로는 \n뒤집어져야 진짜 의미를 찾을 수 있다.\n - 빅토르 위고 -",
    "우리는 모두 자신의 삶을 쓰는 작가다.\n - 막스 프리쉬 -",
    "이야기는 스스로의 목소리를 가진다. \n그리고 그것은 삶 그 자체다.\n - 필립 풀먼 -",
    "삶은 흩어져 있는 사건이 아니라,\n 서로 연결된 이야기들이다.\n - 파울로 코엘료 -",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    final user = ref.read(userProvider);
    if (user != null) {
      ref.read(bookProvider.notifier).setUserId(user.userId);
    }
    _selectedQuote = _quotes[Random().nextInt(_quotes.length)]; // 추가된 부분
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
        return NewDiaryDialog();
      },
    );
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            user.bio_title,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'NanumBarunGothic', // NanumBarunGothicBold 폰트 설정
                            ),
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
                books.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      Expanded(
                        flex: 50,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: books.length + 1, // 프로필 카드 추가
                          onPageChanged: (int index) {
                            setState(() {
                              _selectedDiaryIndex = index;
                              _selectedQuote = _quotes[Random().nextInt(_quotes.length)]; // 추가된 부분
                            });
                          },
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // 첫 번째 항목은 프로필 카드
                              return GestureDetector(
                                onTap: () {
                                  // 프로필 카드 눌렀을 때의 동작 정의
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: EdgeInsets.symmetric(vertical: _selectedDiaryIndex == 0 ? 90 : 90, horizontal: 0),
                                  child: Transform.scale(
                                    scale: _selectedDiaryIndex == 0 ? 1.5 : 1.4, // 가운데 책이 더 커지도록 조정하고 양옆 책의 크기를 줄임
                                    child: ProfileCard(
                                      color: Colors.blue, // 프로필 카드 배경 색상
                                      profileImage: user.profileImage, // 프로필 이미지 URL
                                      name: user.nickname,
                                      birth: DateFormat('yyyy-MM-dd').format(DateTime.parse(user.birth)), // 문자열을 DateTime으로 변환
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final book = books[index - 1];
                              bool isSelected = index == _selectedDiaryIndex;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CustomPageRoute(
                                      page: DiaryScreen(
                                          backgroundColor: Color(int.parse(book.book_cover_image)),
                                          bookId: book.book_id!),
                                      backgroundColor: Color(int.parse(book.book_cover_image)),
                                    ),
                                  );
                                },
                                onLongPress: () => _deleteDiary(context, book.book_id!), // Long press to delete
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: EdgeInsets.symmetric(vertical: isSelected ? 90 : 90, horizontal: 0),
                                  child: Transform.scale(
                                    scale: isSelected ? 1.5 : 1.4, // 가운데 책이 더 커지도록 조정하고 양옆 책의 크기를 줄임
                                    child: DiaryCard(
                                      color: Color(int.parse(book.book_cover_image)),
                                      title: book.book_title,
                                      year: book.book_creation_day.split('-')[0],
                                      theme: book.book_theme,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ), // 하단 공간 추가
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          _selectedQuote, // 수정된 부분
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Maruburi', // 폰트 설정
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
  String _selectedTheme = '해리포터';
  Color _selectedColor = Color(0xFF8B0000);

  final Map<String, Color> _themeColors = {
    '해리포터': Color(0xFF8B0000), // 빨강에 가까운 갈색
    '셜록홈즈': Colors.black,
    '멋진 신세계': Colors.grey,
    '백설공주': Colors.yellow, // 노란색
    '홍길동전': Colors.red,
    '햄릿': Colors.blue,
    '노르웨이 숲': Colors.green,
  };

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
      book_theme: _selectedTheme,
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
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedTheme,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                  _selectedColor = _themeColors[_selectedTheme]!;
                });
              },
              items: _themeColors.keys.map((String theme) {
                return DropdownMenuItem<String>(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Selected Color:'),
            Container(
              width: 50,
              height: 50,
              color: _selectedColor,
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
}
