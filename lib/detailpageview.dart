import 'package:flutter/material.dart';
import 'screens/detail_screen.dart';
class DetailPageView extends StatelessWidget {
  final int initialIndex;
  final Color backgroundColor;
  DetailPageView({required this.initialIndex,required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialIndex);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        title: Text(
          '작성된 글',
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
              '수정',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: 10, // 예시로 10개의 페이지로 설정했습니다. 실제로 필요한 개수로 수정하세요.
        itemBuilder: (context, index) {
          return DetailScreen(index: index, backgroundColor: backgroundColor);
        },
      ),
    );
  }
}