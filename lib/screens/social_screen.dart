import 'package:flutter/material.dart';
import 'diary_card.dart';

class SocialScreen extends StatelessWidget {
  final List<Map<String, dynamic>> diaries = [
    {
      'name': 'John Doe',
      'title': 'John\'s Diary',
      'year': '2023',
      'theme': 'Adventure',
      'color': Colors.blue,
    },
    {
      'name': 'Jane Smith',
      'title': 'Jane\'s Diary',
      'year': '2023',
      'theme': 'Nature',
      'color': Colors.green,
    },
    {
      'name': 'Mike Johnson',
      'title': 'Mike\'s Diary',
      'year': '2023',
      'theme': 'Travel',
      'color': Colors.orange,
    },
    // 다른 사람들의 일기장을 추가하세요.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social'),
      ),
      body: ListView.builder(
        itemCount: diaries.length,
        itemBuilder: (context, index) {
          final diary = diaries[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diary['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
             DiaryCard(
                  color: diary['color'],
                  title: diary['title'],
                  year: diary['year'],
                  theme: diary['theme'],
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
