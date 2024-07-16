import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/page.dart';
import '../services/api_service.dart';

// ApiService Provider
final apiServiceProvider = Provider<ApiService>((ref) => ApiService('https://api.example.com'));

// 사용자 정보 조회 (현재 사용자)
final currentuseProvider = FutureProvider.family<User, String>((ref, userId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchUser(userId);
});

// 전체 사용자의 정보 조회 (회원가입 아이디 중복 검사)
final allUsersProvider = FutureProvider<List<User>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchAllUsers();
});

// 책 정보 조회 (현재 사용자가 보유한 책)
final userBooksProvider = FutureProvider.family<List<Book>, String>((ref, userId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchUserBooks(userId);
});

// 현재 책의 정보 조회
final currentbookProvider = FutureProvider.family<Book, String>((ref, bookId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchBook(bookId);
});

// 테마별 책 정보 조회
final booksByThemeProvider = FutureProvider.family<List<Book>, String>((ref, bookTheme) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchBooksByTheme(bookTheme);
});

// 해당 책의 페이지 정보 조회
final bookPagesProvider = FutureProvider.family<List<Page>, String>((ref, bookId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchBookPages(bookId);
});

// 해당 페이지 정보 조회
final currentpageProvider = FutureProvider.family<Page, String>((ref, pageId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchPage(pageId);
});

// 사용자 추가
final addUserProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (User user) async {
    await apiService.addUser(user);
  };
});

// 책 추가
final addBookProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (Book book) async {
    await apiService.addBook(book);
  };
});

// 페이지 추가
final addPageProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (Page page) async {
    await apiService.addPage(page);
  };
});

// 책 삭제
final deleteBookProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String bookId) async {
    await apiService.deleteBook(bookId);
  };
});

// 페이지 삭제
final deletePageProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String pageId) async {
    await apiService.deletePage(pageId);
  };
});

// 사용자 정보 수정
final editUserProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String userId, Map<String, String> updates) async {
    await apiService.editUser(userId, updates);
  };
});

// 책 정보 수정
final editBookProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String bookId, Map<String, dynamic> updates) async {
    await apiService.editBook(bookId, updates);
  };
});

// 페이지 정보 수정
final editPageProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String pageId, Map<String, dynamic> updates) async {
    await apiService.editPage(pageId, updates);
  };
});

// 스토리 생성
final generateStoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String userStory, String desiredStyle) async {
    return await apiService.generateStory(userStory, desiredStyle);
  };
});

// 감성 분석
final analyzeSentimentProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String text) async {
    return await apiService.analyzeSentiment(text);
  };
});
