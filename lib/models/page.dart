// models/page.dart
class Page {
  final String? page_id;
  final String page_title;
  final String page_content;
  final String page_creation_day;
  final String owner_book;
  final String owner_user;
  final String book_theme;

  Page({
    required this.page_id,
    required this.page_title,
    required this.page_content,
    required this.page_creation_day,
    required this.owner_book,
    required this.owner_user,
    required this.book_theme,
  });
  Page copyWith({
    String? page_id,
    String? page_title,
    String? page_content,
    String? page_creation_day,
    String? owner_book,
    String? owner_user,
    String? book_theme,
  }) {
    return Page(
      page_id: page_id ?? this.page_id,
      page_title: page_title ?? this.page_title,
      page_content: page_content ?? this.page_content,
      page_creation_day: page_creation_day ?? this.page_creation_day,
      owner_book: owner_book ?? this.owner_book,
      owner_user: owner_user ?? this.owner_user,
      book_theme: book_theme ?? this.book_theme,
    );
  }
  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      page_id: json['_id']as String?,
      page_title: json['page_title'],
      page_content: json['page_content'],
      page_creation_day: json['page_creation_day'],
      owner_book: json['owner_book'],
      owner_user: json['owner_user'],
      book_theme: json['book_theme'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': page_id,
      'page_title': page_title,
      'page_content': page_content,
      'page_creation_day': page_creation_day,
      'owner_book': owner_book,
      'owner_user': owner_user,
      'book_theme': book_theme,
    };
  }
}
