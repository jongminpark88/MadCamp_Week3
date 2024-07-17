import 'package:autobio/detailpageview.dart';
import 'package:autobio/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers/page_provider.dart';
import '../trapezoid_painter.dart';
import 'detail_screen.dart';
import 'new_diary_entry_screen.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final String bookId;

  DiaryScreen({required this.backgroundColor,required this.bookId});
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}
class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(pageProvider.notifier).fetchPages(widget.bookId);
  }
  void _navigateToDetail(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPageView(initialIndex: index,backgroundColor: widget.backgroundColor,bookId: widget.bookId),
      ),
    );
  }

  void _navigateToNewDiaryEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewDiaryEntryScreen(backgroundColor: widget.backgroundColor, bookId: widget.bookId),
      ),
    );
  }

  void _deletePage(BuildContext context, String pageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Page'),
          content: Text('Are you sure you want to delete this page?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(pageProvider.notifier).removePage(pageId);
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
    final pages = ref.watch(pageProvider);
    final books = ref.watch(bookProvider);
    final book = books.firstWhere((book) => book.book_id == widget.bookId, orElse: () => Book(
      book_id: '',
      book_title: 'Book not found',
      book_cover_image: '',
      book_creation_day: '',
      owner_user: '',
      book_private: false,
      book_theme: '',
      page_list: [],
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _navigateToNewDiaryEntry(context),
          ),
        ],
      ),
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the text horizontally
                children: [
                  Text(
                    book.book_title,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          Expanded(
            child: pages.isEmpty
                ? Center(
              child: Text(
                'No pages available',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            )
                :  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: pages.length * 60.0 + 20 + 200,
                child: Stack(
                  children: [
                    for (int index = pages.length-1; index >= 0; index--)
                      Positioned(
                        left: index * 80.0 -5,
                        top: 50,
                        child:GestureDetector(
                          onTap:()=> _navigateToDetail(context,index),
                          onLongPress: () => _deletePage(context, pages[index].page_id!),
                        child: CustomPaint(
                          size: Size(150, 600), // 사다리꼴의 크기 설정
                          painter: TrapezoidPainter(
                            color: Colors.white,
                            title: pages[index].page_creation_day,
                          ),
                        ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}