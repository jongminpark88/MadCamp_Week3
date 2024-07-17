import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class EditUserDialog extends ConsumerStatefulWidget {
  final User user;

  EditUserDialog({required this.user});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<EditUserDialog> {
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _biotitleController = TextEditingController();
  File? _profileImage; // 프로필 이미지 파일
  final ImagePicker _picker = ImagePicker();
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.nickname;
    _birthController.text = widget.user.birth;
    _biotitleController.text = widget.user.bio_title;
  }

  Future<void> _selectProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _selectColor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUser() async {
    final updatedUser = widget.user.copyWith(
      nickname: _nameController.text,
      birth: _birthController.text,
      profileImage: _profileImage?.path ?? widget.user.profileImage,
      bio_title: _biotitleController.text,
    );

    await ref.read(userProvider.notifier).updateUser(updatedUser);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectProfileImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : NetworkImage(widget.user.profileImage) as ImageProvider,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _biotitleController,
              decoration: InputDecoration(labelText: '자서전이름'),
            ),
            TextField(
              controller: _birthController,
              decoration: InputDecoration(labelText: 'Birth Date'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(_birthController.text),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _birthController.text = DateFormat('yyyy-MM-dd').format(date);
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectColor,
              child: Text('Select Color'),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 50,
              height: 50,
              color: _selectedColor,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateUser,
          child: Text('Save'),
        ),
      ],
    );
  }
}
