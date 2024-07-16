// models/user.dart
class User {
  final String userId;
  final String password;
  final String profileImage;
  final String nickname;
  final String birth;
  final List<String> bookList;

  User({
    required this.userId,
    required this.password,
    required this.profileImage,
    required this.nickname,
    required this.birth,
    required this.bookList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      password: json['password'],
      profileImage: json['profile_image'],
      nickname: json['nickname'],
      birth: json['birth'],
      bookList: List<String>.from(json['book_list']),
    );
  }
}
