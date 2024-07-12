import 'package:flutter/material.dart';
class TrapezoidPainter extends CustomPainter {
  final Color color;
  final String title;

  TrapezoidPainter({required this.color, required this.title});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    double cornerRadius = 10.0;

    // 시작점 (왼쪽 상단의 약간 아래)
    path.moveTo(0, size.height * 0.1 + cornerRadius);

    // 왼쪽 상단 모서리 (둥근)
    path.arcToPoint(
      Offset(cornerRadius, size.height * 0.1),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // 오른쪽 상단으로 이동
    path.lineTo(size.width - cornerRadius, 0);

    // 오른쪽 상단 모서리 (둥근)
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // 오른쪽 하단으로 이동
    path.lineTo(size.width, size.height - cornerRadius);

    // 오른쪽 하단 모서리 (둥근)
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // 왼쪽 하단으로 이동
    path.lineTo(cornerRadius, size.height * 0.9);

    // 왼쪽 하단 모서리 (둥근)
    path.arcToPoint(
      Offset(0, size.height * 0.9 - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();

    // 그림자 추가
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)));

    canvas.drawPath(path, paint);
/*
    // 그림자 그리기
    var shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawShadow(path.shift(Offset(10, 0)), Colors.black.withOpacity(0.3), 10.0, true);

*/
    // 그림자 그리기
    canvas.drawShadow(
      path.shift(Offset(10, 0)),
      Colors.black.withOpacity(0.4),
      10.0,
      true,
    );


    // 텍스트 그리기
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}