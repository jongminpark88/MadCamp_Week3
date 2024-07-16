import 'package:autobio/providers/api_providers.dart';
import 'package:autobio/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  ProfileScreen({required this.userId});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider(userId));
    return Scaffold(
      body: userAsyncValue.when(
        data: (user)=>Stack(
        children: [
          // 배경 이미지 추가
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // 배경 이미지 경로
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 반투명한 오버레이
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // 프로필 내용
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_picture.png'), // 사용자의 프로필 사진 경로
                ),
                SizedBox(height: 16.0),
                Text(
                  user.nickname,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  user.birth,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24.0),
                // 프로필 정보 카드
                Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  child: ListTile(
                    leading: Icon(Icons.email, color: Colors.orange),
                    title: Text(user.bookList[0]),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.orange),
                    title: Text('+1 234 567 890'),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.orange),
                    title: Text('123 Main Street, City, Country'),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // 로그아웃 로직 추가
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          ),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}