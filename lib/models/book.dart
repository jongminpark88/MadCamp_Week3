
class Book {
  final String bookId;
  final String bookTitle;
  final String bookCoverImage;
  final List<String> pageList;
  final String bookCreationDay;
  final String ownerUser;
  final bool bookPrivate;
  final String bookTheme;

  Book({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverImage,
    required this.pageList,
    required this.bookCreationDay,
    required this.ownerUser,
    required this.bookPrivate,
    required this.bookTheme,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      bookTitle: json['book_title'],
      bookCoverImage: json['book_cover_image'],
      pageList: List<String>.from(json['page_list']),
      bookCreationDay: json['book_creation_day'],
      ownerUser: json['owner_user'],
      bookPrivate: json['book_private'],
      bookTheme: json['book_theme'],
    );
  }
}
