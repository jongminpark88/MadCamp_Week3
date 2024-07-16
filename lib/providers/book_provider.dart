import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/api_service.dart';

// BookNotifier 클래스 정의
class BookNotifier extends StateNotifier<List<Book>> {
  BookNotifier(this.apiService) : super([]);

  final ApiService apiService;

  Future<void> fetchBooks() async {
    state = await apiService.fetchBooks();
  }

  Future<void> addBook(Book book) async {
    await apiService.addBook(book);
    state = [...state, book];
  }

  Future<void> removeBook(String bookId) async {
    await apiService.deleteBook(bookId);
    state = state.where((book) => book.bookId != bookId).toList();
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> updates) async {
    await apiService.editBook(bookId, updates);
    state = state.map((book) {
      if (book.bookId == bookId) {
        return book.copyWith(updates);
      }
      return book;
    }).toList();
  }
}

// BookNotifier를 관리하는 Provider 정의
final bookProvider = StateNotifierProvider<BookNotifier, List<Book>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BookNotifier(apiService);
});
