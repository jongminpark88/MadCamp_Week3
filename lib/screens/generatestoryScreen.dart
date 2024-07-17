import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/api_providers.dart';
import '../providers/page_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../models/page.dart' as models;

class GenerateStoryScreen extends ConsumerStatefulWidget {
  final String content;
  final String bookTheme;
  final Color backgroundColor;
  final String pageId;

  GenerateStoryScreen({
    required this.content,
    required this.bookTheme,
    required this.backgroundColor,
    required this.pageId,
  });

  @override
  _GenerateStoryScreenState createState() => _GenerateStoryScreenState();
}

class _GenerateStoryScreenState extends ConsumerState<GenerateStoryScreen> {
  String? generatedTitle;
  String? generatedStory;
  int? sentimentScore;
  bool isLoading = true;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _generateStory();
  }

  Future<void> _generateStory() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final response = await apiService.generateStory(widget.content, widget.bookTheme);
      setState(() {
        generatedTitle = response['title'];
        generatedStory = response['content'];
        _titleController = TextEditingController(text: generatedTitle);
        _contentController = TextEditingController(text: generatedStory);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        generatedTitle = 'Failed to generate story';
        generatedStory = 'Failed to generate story.';
        isLoading = false;
      });
    }
  }

  Future<void> _analyzeSentiment() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final score = await apiService.analyzeSentiment(generatedStory!);
      setState(() {
        sentimentScore = score;
        isLoading = false;
      });
      print('Sentiment Score: $score');
    } catch (error) {
      print('Failed to analyze sentiment: $error');
      setState(() {
        sentimentScore = null;
        isLoading = false;
      });
    }
  }

  Future<void> _savePage() async {
    final page = ref.read(pageProvider).firstWhere((page) => page.page_id == widget.pageId);
    final updatedPage = page.copyWith(
      page_title: _titleController.text,
      page_content: _contentController.text,
        page_creation_day: page.page_creation_day,
    );
    ref.read(pageProvider.notifier).updatePage(page.page_id!, {
      'page_title': updatedPage.page_title,
      'page_content': updatedPage.page_content,
      'page_creation_day': updatedPage.page_creation_day,
    });
    Navigator.of(context).pop(); // Close the screen after saving
    print('Page updated: ${updatedPage.page_id}');
    print('Title: ${updatedPage.page_title}');
    print('Content: ${updatedPage.page_content}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: widget.backgroundColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          '소설 만들기',
          style: TextStyle(color: widget.backgroundColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: widget.backgroundColor),
            onPressed: _savePage,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: widget.backgroundColor,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                '소설을 생성하는 중입니다...',
                style: TextStyle(color: widget.backgroundColor, fontSize: 18),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.backgroundColor,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(_titleController.text),
                ],
                totalRepeatCount: 1,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(_contentController.text),
                    ],
                    totalRepeatCount: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '감정분석점수: ${sentimentScore ?? ''}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _analyzeSentiment,
              child: Text('감정분석'),
            ),
          ],
        ),
      ),
    );
  }
}