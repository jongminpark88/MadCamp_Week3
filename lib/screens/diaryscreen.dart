import 'package:autobio/detailpageview.dart';
import 'package:flutter/material.dart';
import '../trapezoid_painter.dart';
import 'detail_screen.dart';
import 'new_diary_entry_screen.dart';
class DiaryScreen extends StatelessWidget {
  final Color backgroundColor;

  DiaryScreen({required this.backgroundColor});
  void _navigateToDetail(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPageView(initialIndex: index,backgroundColor: backgroundColor),
      ),
    );
  }
  void _navigateToNewDiaryEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewDiaryEntryScreen(backgroundColor: backgroundColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the text horizontally
                children: [
                  Text(
                    'My Diary',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 8 * 60.0 + 20 + 200,
                child: Stack(
                  children: [
                    for (int index = 8; index >= 0; index--)
                      Positioned(
                        left: index * 80.0 -5,
                        top: 50,
                        child:GestureDetector(
                          onTap:()=> _navigateToDetail(context,index),
                        child: CustomPaint(
                          size: Size(150, 600), // 사다리꼴의 크기 설정
                          painter: TrapezoidPainter(
                            color: Colors.white,
                            title: 'Section ${index + 1}',
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