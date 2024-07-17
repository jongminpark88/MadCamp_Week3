import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/page.dart';
import '../services/api_service.dart';
import 'api_providers.dart';

// PageNotifier 클래스 정의
class PageNotifier extends StateNotifier<List<Page>> {
  PageNotifier(this.apiService) : super([]);

  final ApiService apiService;

  Future<void> fetchPages(String bookId) async {
    state = await apiService.fetchBookPages(bookId);
  }

  Future<Page> addPage(Page page) async {
    final createdPage = await apiService.addPage(page);
    state = [...state, createdPage];
    print('Page added to state: ${createdPage.page_title}, id: ${createdPage.page_id}');
    return createdPage;
  }

  Future<void> removePage(String pageId) async {
    await apiService.deletePage(pageId);
    state = state.where((page) => page.page_id != pageId).toList();
  }

  Future<void> updatePage(String pageId, Map<String, dynamic> updates) async {
    await apiService.editPage(pageId, updates);
    state = state.map((page) {
      if (page.page_id == pageId) {
        return page.copyWith(
          page_title: updates['page_title'] as String?,
          page_content: updates['page_content'] as String?,
          page_creation_day: updates['page_creation_day'] as String?,
          owner_book: updates['owner_book'] as String?,
          owner_user: updates['owner_user'] as String?,
          book_theme: updates['book_theme'] as String?,
        );
      }
      return page;
    }).toList();
  }
}

// PageNotifier를 관리하는 Provider 정의
final pageProvider = StateNotifierProvider<PageNotifier, List<Page>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PageNotifier(apiService);
});
