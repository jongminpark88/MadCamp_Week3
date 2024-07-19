import 'package:autobio/screens/diary_card.dart';
import 'package:flutter/material.dart';
import 'diaryscreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipping = false;
  int _selectedDiaryIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
merge
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipDiary(int index) {
    setState(() {
      _isFlipping = true;
      _selectedDiaryIndex = index;
    });
    _controller.forward().then((_) {
      Navigator.of(context).push(_createRoute()).then((_) {
        _controller.reset();
        setState(() {
          _isFlipping = false;
        });
      });
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DiaryScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  'Diary',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _flipDiary(index),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        double angle = _animation.value * 3.1415927;
                        if (_isFlipping && _selectedDiaryIndex == index) {
                          if (angle > 1.5708) {
                            angle = 3.1415927 - angle;
                          }
                          return Transform(
                            transform: Matrix4.rotationY(angle),
                            alignment: Alignment.center,
                            child: _animation.value > 0.5
                                ? Container(
                              width: 160,
                              height: 240,
                              color: Colors.transparent,
                            )
                                : child,
                          );
                        }
                        return child!;
                      },
                      child: DiaryCard(
                        color: index.isEven ? Colors.orange : Colors.red,
                        title: 'MY DIARY',
                        year: '202${index}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Write down today's text\nTell your story.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.orange),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}