import 'package:autobio/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/api_service.dart';

// BookNotifier 클래스 정의
class BookNotifier extends StateNotifier<List<Book>> {
  final ApiService apiService;
  String? userId;

  BookNotifier(this.apiService) : super([]);

  Future<void> fetchBooks() async {
    if (userId != null) {
      state = await apiService.fetchUserBooks(userId!);
      print('Books fetched for user: $userId'); // 로그 추가
    }
  }

  Future<Book> addBook(Book book) async {
    final createdBook = await apiService.addBook(book);
    state = [...state, createdBook];
    print('Book added to state: ${createdBook.book_title}, id: ${createdBook.book_id}');
    return createdBook; // Return the created book
  }

  Future<void> removeBook(String bookId) async {
    await apiService.deleteBook(bookId);
    state = state.where((book) => book.book_id != bookId).toList();
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> updates) async {
    await apiService.editBook(bookId, updates);
    state = state.map((book) {
      if (book.book_id == bookId) {
        return book.copyWith(
          book_title: updates['book_title'] as String?,
          book_cover_image: updates['book_cover_image'] as String?,
          page_list: updates['page_list'] as List<String>?,
          book_creation_day: updates['book_creation_day'] as String?,
          owner_user: updates['owner_user'] as String?,
          book_private: updates['book_private'] as bool?,
          book_theme: updates['book_theme'] as String?,
        );
      }
      return book;
    }).toList();
  }

  void setUserId(String userId) {
    this.userId = userId;
    fetchBooks();
  }
}

// BookNotifier를 관리하는 Provider 정의
final bookProvider = StateNotifierProvider<BookNotifier, List<Book>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BookNotifier(apiService);
});