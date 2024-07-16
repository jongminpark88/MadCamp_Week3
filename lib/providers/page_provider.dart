import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/page.dart';
import '../services/api_service.dart';
/*
// PageNotifier 클래스 정의
class PageNotifier extends StateNotifier<List<Page>> {
  PageNotifier(this.apiService) : super([]);

  final ApiService apiService;

  Future<void> fetchPages(String bookId) async {
    state = await apiService.fetchBookPages(bookId);
  }

  Future<void> addPage(Page page) async {
    await apiService.addPage(page);
    state = [...state, page];
  }

  Future<void> removePage(String pageId) async {
    await apiService.deletePage(pageId);
    state = state.where((page) => page.pageId != pageId).toList();
  }

  Future<void> updatePage(String pageId, Map<String, dynamic> updates) async {
    await apiService.editPage(pageId, updates);
    state = state.map((page) {
      if (page.pageId == pageId) {
        return page.copyWith(updates);
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
*/