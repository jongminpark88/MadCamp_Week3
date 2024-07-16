import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_providers.dart';

class GenerateStoryScreen extends ConsumerStatefulWidget {
  //final Color backgroundColor;
  final String content;
  final String bookTheme;

  GenerateStoryScreen({required this.content, required this.bookTheme});

  @override
  _GenerateStoryScreenState createState() => _GenerateStoryScreenState();
}

class _GenerateStoryScreenState extends ConsumerState<GenerateStoryScreen> {
  String? generatedTitle;
  String? generatedStory;
  int? sentimentScore;
  bool isLoading = true;

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
      });
      _analyzeSentiment(response['content']!);
    } catch (error) {
      setState(() {
        generatedTitle = 'Failed to generate story';
        generatedStory = 'Failed to generate story.';
        isLoading = false;
      });
    }
  }

  Future<void> _analyzeSentiment(String story) async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final score = await apiService.analyzeSentiment(story);
      setState(() {
        sentimentScore = score;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        sentimentScore = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Story'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                generatedTitle ?? 'No title generated',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                generatedStory ?? 'No story generated',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Sentiment Score: ${sentimentScore ?? 'N/A'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
