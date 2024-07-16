import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/api_providers.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';
import 'package:autobio/main.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _user_idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  /*
  Future setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
  }
   */
  Future<void> _login() async {
    final user_id = _user_idController.text;
    final password = _passwordController.text;

    try {
      final apiService = ref.read(apiServiceProvider);
      final user = await apiService.login(user_id, password);
      ref.read(userProvider.notifier).setUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid userid or password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) => SignUpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _user_idController,
              decoration: InputDecoration(labelText: 'UserID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: _showSignUpDialog,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpDialog extends ConsumerStatefulWidget {
  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends ConsumerState<SignUpDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _biotitleController = TextEditingController();

  File? _profilePicture; // 기본 이미지
  final ImagePicker _picker = ImagePicker();

  void _selectProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  Future<void> _signUp() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String birthdate = _birthdateController.text;
    final String bio_title = _biotitleController.text;

    if (username.isEmpty || password.isEmpty || name.isEmpty || birthdate.isEmpty|| bio_title.isEmpty) {
      // 입력값 유효성 검사
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    final String profileImage = _profilePicture?.path ?? 'assets/images.png';
    final List<String> bookList = []; // 기본 값 또는 사용자 입력값으로 설정

    final User newUser = User(
      userId: username,
      password: password,
      profileImage: profileImage,
      nickname: name,
      birth: birthdate,
      bio_title: bio_title,
      bookList: bookList,
    );

    try {
      final createduser= await ref.read(addUserProvider)(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign Up'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectProfilePicture,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : AssetImage('assets/profile_placeholder.png') as ImageProvider,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: '생일'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _birthdateController.text = date.toLocal().toString().split(' ')[0];
                }
              },
            ),
            TextField(
              controller: _biotitleController,
              decoration: InputDecoration(labelText: '자서전 이름'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: _signUp,
          child: Text('회원가입'),
        ),
      ],
    );
  }
}