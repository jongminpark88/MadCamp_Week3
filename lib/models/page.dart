// models/page.dart
class Page {
  final String pageId;
  final String pageTitle;
  final String pageContent;
  final String pageCreationDay;
  final String ownerBook;
  final String ownerUser;
  final String bookTheme;

  Page({
    required this.pageId,
    required this.pageTitle,
    required this.pageContent,
    required this.pageCreationDay,
    required this.ownerBook,
    required this.ownerUser,
    required this.bookTheme,
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      pageId: json['page_id'],
      pageTitle: json['page_title'],
      pageContent: json['page_content'],
      pageCreationDay: json['page_creation_day'],
      ownerBook: json['owner_book'],
      ownerUser: json['owner_user'],
      bookTheme: json['book_theme'],
    );
  }
}
