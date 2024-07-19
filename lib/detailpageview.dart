import 'package:autobio/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/detail_screen.dart';
class DetailPageView extends ConsumerWidget {
  final int initialIndex;
  final Color backgroundColor;
  final String bookId;
  DetailPageView({required this.initialIndex,required this.backgroundColor,required this.bookId});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final pages = ref.watch(pageProvider);
    PageController controller = PageController(initialPage: initialIndex);

    return Scaffold(
      /*
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        title: Text(
          '작성된 글',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),*/
      body: pages.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : PageView.builder(
        controller: controller,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return DetailScreen(
            index: index,
            backgroundColor: backgroundColor,
            bookId: bookId,
            pageId: page.page_id!,
          );
        },
      ),
    );
  }
}