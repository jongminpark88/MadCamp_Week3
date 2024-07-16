import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/book.dart';
import '../models/page.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);
  // 로그인 메서드 추가
  Future<User> login(String user_id, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': user_id,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
  // 사용자 정보 조회 (현재 사용자)
  Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // 전체 사용자의 정보 조회 (회원가입 아이디 중복 검사)
  Future<List<User>> fetchAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/user'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // 책 정보 조회 (현재 사용자가 보유한 책)
  Future<List<Book>> fetchUserBooks(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/book/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user books');
    }
  }

  // 현재 책의 정보 조회
  Future<Book> fetchBook(String bookId) async {
    final response = await http.get(Uri.parse('$baseUrl/book/$bookId'));

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }

  // 테마별 책 정보 조회
  Future<List<Book>> fetchBooksByTheme(String bookTheme) async {
    final response = await http.get(Uri.parse('$baseUrl/book/theme/$bookTheme'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books by theme');
    }
  }

  // 해당 책의 페이지 정보 조회
  Future<List<Page>> fetchBookPages(String bookId) async {
    final response = await http.get(Uri.parse('$baseUrl/page/book/$bookId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Page.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load book pages');
    }
  }

  // 해당 페이지 정보 조회
  Future<Page> fetchPage(String pageId) async {
    final response = await http.get(Uri.parse('$baseUrl/page/$pageId'));

    if (response.statusCode == 200) {
      return Page.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load page');
    }
  }

  // 사용자 추가
  Future<User> addUser(User user) async {
    print('addUser 호출됨: $user'); // 로그 추가
    final response = await http.post(
      Uri.parse('$baseUrl/user/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': user.userId,
        'password': user.password,
        'profile_image': user.profileImage,
        'nickname': user.nickname,
        'birth': user.birth,
        'bio_title': user.bio_title,
        'book_list': user.bookList,
      }),
    );
    //print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add book');
    }
  }

  // 책 추가
  Future<Book> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book/${book.owner_user}/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'book_title': book.book_title,
        'book_cover_image': book.book_cover_image,
        'page_list': book.page_list,
        'book_creation_day': book.book_creation_day,
        'owner_user': book.owner_user,
        'book_private': book.book_private,
        'book_theme': book.book_theme,
      }),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add book');
    }
  }

  // 페이지 추가
  Future<Page> addPage(Page page) async {
    final response = await http.post(
      Uri.parse('$baseUrl/page/${page.owner_book}/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'page_title': page.page_title,
        'page_content': page.page_content,
        'page_creation_day': page.page_creation_day,
        'owner_book': page.owner_book,
        'owner_user': page.owner_user,
        'book_theme': page.book_theme,
      }),
    );
    if (response.statusCode == 200) {
      return Page.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add book');
    }
  }

  // 책 삭제
  Future<void> deleteBook(String bookId) async {
    final response = await http.delete(Uri.parse('$baseUrl/book/delete/$bookId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }

  // 페이지 삭제
  Future<void> deletePage(String pageId) async {
    final response = await http.delete(Uri.parse('$baseUrl/page/delete/$pageId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete page');
    }
  }

  // 사용자 정보 수정
  Future<void> editUser(String userId, Map<String, String> updates) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/edit/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit user');
    }
  }

  // 책 정보 수정
  Future<void> editBook(String bookId, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('$baseUrl/book/edit/$bookId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit book');
    }
  }

  // 페이지 정보 수정
  Future<void> editPage(String pageId, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('$baseUrl/page/edit/$pageId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit page');
    }
  }

  // 스토리 생성
  Future<Map<String, String>> generateStory(String user_story, String desired_style) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_story': user_story,
        'desired_style': desired_style,
      }),
    );
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to generate story');
    }
  }

  // 감성분석
  Future<int> analyzeSentiment(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sentiment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text}),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['sentiment_score'];
    } else {
      throw Exception('Failed to analyze sentiment');
    }
  }
}
