
class Book {
  final String? book_id;
  final String book_title;
  final String book_cover_image;
  final List<String> page_list;
  final String book_creation_day;
  final String owner_user;
  final bool book_private;
  final String book_theme;

  Book({
    this.book_id,
    required this.book_title,
    required this.book_cover_image,
    required this.page_list,
    required this.book_creation_day,
    required this.owner_user,
    required this.book_private,
    required this.book_theme,
  });
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      book_id: json['book_id'],
      book_title: json['book_title'],
      book_cover_image: json['book_cover_image'],
      page_list: List<String>.from(json['page_list']),
      book_creation_day: json['book_creation_day'],
      owner_user: json['owner_user'],
      book_private: json['book_private'],
      book_theme: json['book_theme'],
    );
  }
}
