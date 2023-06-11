import 'package:flutter/material.dart';

class PolygonConnectionPainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  PolygonConnectionPainter({required this.startPoint, required this.endPoint});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PolygonConnectionPainter oldDelegate) {
    return startPoint != oldDelegate.startPoint || endPoint != oldDelegate.endPoint;
  }
}
