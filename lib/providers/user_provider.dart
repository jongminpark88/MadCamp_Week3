import 'package:autobio/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
/*
class UserStateNotifier extends StateNotifier<User?> {
  UserStateNotifier() : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final profileImage = prefs.getString('profileImage');
    final birth = prefs.getString('birth');

    if (userId != null && userName != null && profileImage != null && birth != null) {
      state = User(
        userId: userId,
        password: '', // 비밀번호는 저장하지 않습니다.
        profileImage: profileImage,
        nickname: userName,
        birth: birth,
        bookList: [], // 기본 값으로 설정
      );
    }
  }

  Future<void> setUser(User user) async {
    state = user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.userId);
    prefs.setString('userName', user.nickname);
    prefs.setString('profileImage', user.profileImage);
    prefs.setString('birth', user.birth);
  }

  Future<void> clearUser() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userName');
    prefs.remove('profileImage');
    prefs.remove('birth');
  }
}

final userStateNotifierProvider = StateNotifierProvider<UserStateNotifier, User?>((ref) {
  return UserStateNotifier();
});
*/
class UserNotifier extends StateNotifier<User?> {
  final ApiService apiService;

  UserNotifier(this.apiService) : super(null);

  void setUser(User user) {
    state = user;
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      await apiService.editUser(updatedUser.userId, {
        'nickname': updatedUser.nickname,
        'birth': updatedUser.birth,
        'profileImage': updatedUser.profileImage,
        'bio_title': updatedUser.bio_title,
        'password': updatedUser.password, // Ensure password is included
        'profile_image': updatedUser.profileImage // Ensure profile_image field is included
      });
      state = updatedUser;
    } catch (e) {
      print('Error updating user: $e');
      throw e; // Optional: rethrow the error if you want to handle it further up the call stack
    }
  }
}
// UserNotifier를 관리하는 Provider 정의
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserNotifier(apiService);
});