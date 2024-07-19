// models/user.dart
class User {
  final String userId;
  final String password;
  final String profileImage;
  final String nickname;
  final String birth;
  final String bio_title;
  final List<String> bookList;

  User({
    required this.userId,
    required this.password,
    required this.profileImage,
    required this.nickname,
    required this.birth,
    required this.bio_title,
    required this.bookList,
  });
  User copyWith({
    String? userId,
    String? password,
    String? profileImage,
    String? nickname,
    String? birth,
    String? bio_title,
    List<String>? bookList,
  }) {
    return User(
      userId: userId ?? this.userId,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
      nickname: nickname ?? this.nickname,
      birth: birth ?? this.birth,
      bio_title: bio_title ?? this.bio_title,
      bookList: bookList ?? this.bookList,
    );
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      password: json['password'],
      profileImage: json['profile_image'],
      nickname: json['nickname'],
      birth: json['birth'],
      bio_title: json['bio_title'],
      bookList: List<String>.from(json['book_list']),
    );
  }
}
