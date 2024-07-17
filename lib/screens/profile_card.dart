import 'package:flutter/material.dart';
import 'dart:io';

class ProfileCard extends StatelessWidget {
  final Color color;
  final String profileImage;
  final String name;
  final String birth;

  ProfileCard({required this.color, required this.profileImage, required this.name, required this.birth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: 200,
      height: 240,
      child: Column(
        children: [
          Container(
            width: 190,
            height: 220,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profileImage.startsWith('http')
                        ? NetworkImage(profileImage)
                        : FileImage(File(profileImage)) as ImageProvider,
                  ),
                  SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Maruburi', // 글씨체 변경
                    ),
                  ),
                  Text(
                    birth,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'Maruburi', // 글씨체 변경
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 190,
            height: 20,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: color,
                    width: 5.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 190,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

