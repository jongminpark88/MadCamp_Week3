import 'package:flutter/material.dart';
import '../trapezoid_painter.dart';

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  'Diary',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                        child: CustomPaint(
                          size: Size(150, 600), // 사다리꼴의 크기 설정
                          painter: TrapezoidPainter(
                            color: Colors.primaries[index % Colors.primaries.length],
                            title: 'Section ${index + 1}',
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
    );
  }
}