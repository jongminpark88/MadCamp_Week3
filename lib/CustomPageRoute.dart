import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final Color backgroundColor;

  CustomPageRoute({required this.page, required this.backgroundColor})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          double value = animation.value;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY((1-value) * 1.2), // Rotate from right to left
            alignment: Alignment.centerLeft,
            child: child,
          );
        },
        child: child,
      );
    },
  );
}
