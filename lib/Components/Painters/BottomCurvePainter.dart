import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musicsoul/Components/ScreenBasicElements.dart';

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(width, height) / 2;
    final centerWidth = width / 2;
    final centerHeight = height / 2;
    final center = Offset(centerWidth, centerHeight);
    final outlinePaint = Paint()
      ..shader = LinearGradient(
              colors: [Color.fromARGB(255, 185, 180, 180), defaulColor])
          .createShader(Rect.fromLTWH(0, 0, width, height))
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Path path = Path();
    path.quadraticBezierTo(centerWidth, height, width, 0);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
