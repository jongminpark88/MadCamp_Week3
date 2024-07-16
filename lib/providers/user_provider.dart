import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
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
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}
// UserNotifier를 관리하는 Provider 정의
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});