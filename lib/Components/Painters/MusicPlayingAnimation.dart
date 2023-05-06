import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class customCircle extends CustomPainter {
  late BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(width, height) / 2;
    final centerWidth = width / 2;
    final centerHeight = height / 2;
    final center = Offset(centerWidth, centerHeight);
    final outlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius * 0.12
      ..style = PaintingStyle.stroke;
    final smOutlinePaint = Paint()
      ..color = Color.fromARGB(255, 110, 103, 103)
      ..strokeWidth = radius * 0.004
      ..style = PaintingStyle.stroke;
    final centerCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outlinePaint);
    canvas.drawCircle(center, radius * 0.97, centerCirclePaint);
    canvas.drawCircle(center, radius * 0.86, smOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MusicStarterPainter extends CustomPainter {
  late BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(width, height) / 2;
    final centerWidth = width / 2;
    final centerHeight = height / 2;
    final center = Offset(centerWidth, centerHeight);
    Paint paint = Paint()..color = Color.fromRGBO(23, 28, 38, 1);
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.1;
    Paint smallLinePaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.04;
    Path path = Path();
    //Drawing start square
    canvas.drawCircle(Offset(width * 0.5, height * 0.14), radius * 0.4, paint);

    // path.moveTo(width * 0.45, height * 0.03);
    // path.lineTo(width * 0.55, height * 0.03);
    // path.lineTo(width * 0.55, height * 0.08);
    // path.lineTo(width * 0.45, height * 0.08);
    path.close();
    //Drawing small
    Path path1 = Path();
    path1.moveTo(width * 0.55, height * 0.08);
    path1.lineTo(width * 0.53, height * 0.098);
    path1.lineTo(width * 0.47, height * 0.098);
    path1.lineTo(width * 0.45, height * 0.08);
    // canvas.drawPath(
    //     path1,
    //     Paint()
    //       ..color = Color.fromARGB(255, 99, 96, 96)
    //       ..strokeCap = StrokeCap.round);
    //drawing big line
    path.moveTo(width * 0.53, height * 0.098);
    path.lineTo(width * 0.53, height * 0.24);
    path.lineTo(width * 0.47, height * 0.24);
    path.lineTo(width * 0.47, height * 0.098);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.grey
          ..strokeCap = StrokeCap.round);

    //Drawing black trigger
    Path path2 = Path();
    path2.moveTo(width * 0.53, height * 0.24);
    path2.lineTo(width * 0.53, height * 0.27);

    path2.lineTo(width * 0.72, height * 0.41);
    path2.quadraticBezierTo(
        width * 0.78, height * 0.47, width * 0.66, height * 0.52);
    path2.lineTo(width * 0.57, height * 0.56);

    path2.lineTo(width * 0.53, height * 0.54);
    path2.lineTo(width * 0.65, height * 0.485);
    path2.quadraticBezierTo(
        width * 0.71, height * 0.45, width * 0.635, height * 0.4);
    path2.lineTo(width * 0.47, height * 0.28);
    path2.lineTo(width * 0.47, height * 0.24);
    path2.close();
    canvas.drawPath(path2, Paint()..color = Colors.black);
    canvas.drawLine(Offset(width * 0.565, height * 0.56),
        Offset(width * 0.527, height * 0.54), linePaint);
    //Drawing last part
    Path path3 = Path();
    path3.moveTo(width * 0.552, height * 0.565);
    path3.lineTo(width * 0.4, height * 0.62);
    path3.lineTo(width * 0.365, height * 0.6);
    path3.lineTo(width * 0.512, height * 0.546);
    canvas.drawPath(path3, paint);
    canvas.drawLine(Offset(width * 0.415, height * 0.605),
        Offset(width * 0.456, height * 0.59), smallLinePaint);
    canvas.drawLine(Offset(width * 0.4, height * 0.595),
        Offset(width * 0.44, height * 0.581), smallLinePaint);
    //Drawing top circles
    canvas.drawCircle(
        Offset(width * 0.5, height * 0.14),
        radius * 0.12,
        Paint()
          ..color = Color.fromARGB(255, 128, 123, 123)
          ..strokeWidth = radius * 0.02);
    canvas.drawCircle(
        Offset(width * 0.5, height * 0.14),
        radius * 0.15,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.1);
    canvas.drawCircle(
        Offset(width * 0.5, height * 0.14),
        radius * 0.16,
        paint
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = radius * 0.03);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MusicHolderPainter extends CustomPainter {
  late BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(width, height) / 2;
    final centerWidth = width / 2;
    final centerHeight = height / 2;
    final center = Offset(centerWidth, centerHeight);
    Paint paint = Paint()..color = Color.fromRGBO(23, 28, 38, 1);

    Path path = Path();

    path.moveTo(width * 0.45, height * 0.03);
    path.lineTo(width * 0.55, height * 0.03);
    path.lineTo(width * 0.55, height * 0.08);
    path.lineTo(width * 0.45, height * 0.08);
    path.close();
    //Drawing small
    Path path1 = Path();
    path1.moveTo(width * 0.55, height * 0.08);
    path1.lineTo(width * 0.53, height * 0.098);
    path1.lineTo(width * 0.47, height * 0.098);
    path1.lineTo(width * 0.45, height * 0.08);
    canvas.drawPath(
        path1,
        Paint()
          ..color = Color.fromARGB(255, 99, 96, 96)
          ..strokeCap = StrokeCap.round);
    //drawing big line

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.grey
          ..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(width * 0.64, height * 0.138), 1.6,
        Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double degToRad(double deg) {
  return deg * pi / 180;
}
